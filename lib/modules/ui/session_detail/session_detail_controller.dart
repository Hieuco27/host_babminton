import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:host_babminton/core/database_service.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:host_babminton/data/models/attendance.dart';
import 'package:host_babminton/data/models/invoice.dart';
import 'package:host_babminton/data/models/extra_fee.dart';
import 'package:isar/isar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:host_babminton/core/text_styles.dart';
import 'package:host_babminton/modules/ui/finance/finance_controller.dart';

class SessionDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late Isar db;

  final GlobalKey repaintBoundaryKey = GlobalKey();

  var selectedTab = 0.obs;

  var courtFeeController = TextEditingController();
  var shuttlecockPriceController = TextEditingController();
  var shuttlecockCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });

    _initData();
  }

  Future<void> _initData() async {
    db = await Get.find<DatabaseService>().db;

    int? sessionId;
    if (Get.arguments is int) {
      sessionId = Get.arguments as int;
    } else if (Get.arguments is Map) {
      sessionId = Get.arguments['id'] as int?;
    }

    if (sessionId != null) {
      await loadSession(sessionId);
    }
  }

  Rx<Session?> currentSession = Rx<Session?>(null);
  var attendanceList = <Attendance>[].obs;
  var extraFees = <ExtraFee>[].obs;
  var currentInvoice = Rxn<Invoice>();

  Future<void> loadSession(int id) async {
    final session = await db.sessions.get(id);
    if (session != null) {
      await session.venue.load();
      currentSession.value = session;

      final attendances = await db.attendances
          .filter()
          .session((q) => q.idEqualTo(id))
          .findAll();
      for (var att in attendances) {
        await att.member.load();
      }
      attendanceList.value = attendances;

      final extras = await db.extraFees
          .filter()
          .session((q) => q.idEqualTo(id))
          .findAll();
      extraFees.value = extras;

      final invoice = await db.invoices
          .filter()
          .session((q) => q.idEqualTo(id))
          .findFirst();
      currentInvoice.value = invoice;

      if (invoice != null) {
        courtFeeController.text = invoice.courtFee.toString();
        shuttlecockPriceController.text = invoice.shuttlecockPrice.toString();
        shuttlecockCount.value = invoice.shuttlecockCount;
      } else {
        courtFeeController.text =
            (session.courtPricePerHour * session.numberOfCourts * 2)
                .toString(); // Roughly
        shuttlecockPriceController.text = '28000';
      }
    }
  }

  Future<void> checkout() async {
    final session = currentSession.value;
    if (session == null) return;

    int courtFee =
        int.tryParse(
          courtFeeController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    int sPrice =
        int.tryParse(
          shuttlecockPriceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    int sCount = shuttlecockCount.value;

    int totalExtras = extraFees.fold(0, (sum, item) => sum + item.amount);
    int totalCost = courtFee + (sPrice * sCount) + totalExtras;

    int presentMales = attendanceList
        .where(
          (a) => a.attendanceStatus == AttendanceStatus.present && a.isMale,
        )
        .length;
    int presentFemales = attendanceList
        .where(
          (a) => a.attendanceStatus == AttendanceStatus.present && !a.isMale,
        )
        .length;
    int totalPresent = presentMales + presentFemales;

    int maleFee = 0;
    int femaleFee = 0;

    if (totalPresent > 0) {
      double averageFee = totalCost / totalPresent;
      if (averageFee < 45000 || presentMales == 0) {
        maleFee = averageFee.ceil();
        femaleFee = averageFee.ceil();
      } else {
        femaleFee = 45000;
        int remainingCostForMales = totalCost - (femaleFee * presentFemales);
        maleFee = (remainingCostForMales / presentMales).ceil();
      }
    }

    // Round to nearest 1000
    maleFee = ((maleFee + 999) ~/ 1000) * 1000;
    femaleFee = ((femaleFee + 999) ~/ 1000) * 1000;

    await db.writeTxn(() async {
      // Create invoice
      final invoice = Invoice(
        courtFee: courtFee,
        shuttlecockCount: sCount,
        shuttlecockPrice: sPrice,
        maleFee: maleFee,
        femaleFee: femaleFee,
      );
      await db.invoices.put(invoice);
      invoice.session.value = session;
      await invoice.session.save();

      // Update attendances
      for (var att in attendanceList) {
        if (att.attendanceStatus == AttendanceStatus.present) {
          att.feeToPay = att.isMale ? maleFee : femaleFee;
          await db.attendances.put(att);
        }
      }

      // Update session status
      session.status = SessionStatus.checkout;
      session.checkoutTime = DateTime.now();
      await db.sessions.put(session);
    });

    await loadSession(session.id);

    if (Get.isRegistered<FinanceController>()) {
      Get.find<FinanceController>().loadData();
    }
  }

  Future<void> togglePaymentStatus(Attendance attendance) async {
    await db.writeTxn(() async {
      attendance.paymentStatus = attendance.paymentStatus == PaymentStatus.paid
          ? PaymentStatus.unpaid
          : PaymentStatus.paid;
      await db.attendances.put(attendance);
    });

    // Refresh the reactive list
    final index = attendanceList.indexWhere((a) => a.id == attendance.id);
    if (index != -1) {
      attendanceList[index] = attendance;
      attendanceList.refresh();
    }

    if (Get.isRegistered<FinanceController>()) {
      Get.find<FinanceController>().loadData();
    }
  }

  Future<void> markAllAsPaid() async {
    await db.writeTxn(() async {
      for (var att in attendanceList) {
        if (att.attendanceStatus == AttendanceStatus.present &&
            att.paymentStatus == PaymentStatus.unpaid) {
          att.paymentStatus = PaymentStatus.paid;
          await db.attendances.put(att);
        }
      }
    });

    // Reload attendance list to refresh UI
    if (currentSession.value != null) {
      await loadSession(currentSession.value!.id);
    }

    if (Get.isRegistered<FinanceController>()) {
      Get.find<FinanceController>().loadData();
    }
  }

  void incrementShuttlecock() {
    if (shuttlecockCount.value < 30) shuttlecockCount.value++;
  }

  void decrementShuttlecock() {
    if (shuttlecockCount.value > 0) shuttlecockCount.value--;
  }

  @override
  void onClose() {
    tabController.dispose();
    courtFeeController.dispose();
    shuttlecockPriceController.dispose();
    super.onClose();
  }

  Future<void> captureFullList(BuildContext context) async {
    final screenshotController = ScreenshotController();
    final members = attendanceList;
    final session = currentSession.value;

    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                final venue = session?.venue.value;
                String statusStr = 'Nháp';
                if (session?.status == SessionStatus.checkout)
                  statusStr = 'Quyết toán';
                if (session?.status == SessionStatus.closed)
                  statusStr = 'Đã chốt';

                int weekday = session?.date.weekday ?? 1;
                String weekdayStr = weekday == 7 ? 'CN' : 'T${weekday + 1}';
                String timeStr =
                    '$weekdayStr, ${session?.date.day.toString().padLeft(2, '0')}/${session?.date.month.toString().padLeft(2, '0')} · ${session?.startTime} – ${session?.endTime}';

                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFE8ECEA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            timeStr,
                            style: AppTextStyles.bodyLarge(
                              color: const Color(0xFF14211A),
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8ECEA),
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: Text(
                              statusStr,
                              style: AppTextStyles.titleSmall3(
                                color: const Color(0xFF68776F),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20.w,
                            color: const Color(0xFF68776F),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: venue?.name ?? 'Chưa rõ sân',
                                    style: AppTextStyles.titleSmall3(
                                      color: const Color(0xFF14211A),
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  if (venue?.address.isNotEmpty == true)
                                    TextSpan(
                                      text: ' • ${venue!.address}',
                                      style: AppTextStyles.titleSmall3(
                                        color: const Color(0xFF14211A),
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  if (session?.courtNumbers?.isNotEmpty == true)
                                    TextSpan(
                                      text:
                                          ' • Sân số: ${session!.courtNumbers}',
                                      style: AppTextStyles.titleSmall3(
                                        color: const Color(0xFF146C43),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  'Danh sách (${members.length}/${session?.maxPlayers ?? 0})',
                  style: AppTextStyles.titleMediumBlack().copyWith(),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ...members.map((attendance) {
              final memberName = attendance.member.value?.name ?? '';
              final isMale = attendance.isMale;
              final isPaid = attendance.paymentStatus == PaymentStatus.paid;

              return Container(
                height: 45.h,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE1E6E3), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32.w,
                      child: Text(
                        '${members.indexOf(attendance) + 1}',
                        style: AppTextStyles.labelLarge(
                          color: const Color(0xFF14211A),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        memberName,
                        style: AppTextStyles.labelLarge(
                          color: const Color(0xFF14211A),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          isMale ? 'Nam' : 'Nữ',
                          style: AppTextStyles.labelMedium().copyWith(
                            color: isMale ? Colors.blue : Colors.pink,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 88.w,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          isPaid ? 'Đã TT' : 'Chưa TT',
                          style: AppTextStyles.labelMedium().copyWith(
                            color: isPaid ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Nam: ${members.where((m) => m.isMale).length}',
                    style: AppTextStyles.titleMediumBlack().copyWith(
                      color: const Color(0xFF1459B3),
                    ),
                  ),
                  Text(
                    'Nữ: ${members.where((m) => !m.isMale).length}',
                    style: AppTextStyles.titleMediumBlack().copyWith(
                      color: const Color(0xFFC8431B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final imageBytes = await screenshotController.captureFromWidget(
        widget,
        context: context,
        pixelRatio: 3.0,
      );

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/danh_sach_diem_danh.png');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Danh sách điểm danh');
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
    }
  }
}
