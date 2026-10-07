import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:host_babminton/core/database_service.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:host_babminton/data/models/member.dart';
import 'package:host_babminton/data/models/attendance.dart';
import 'package:host_babminton/data/models/invoice.dart';
import 'package:host_babminton/data/models/extra_fee.dart';
import 'package:isar/isar.dart';

class SessionDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late Isar db;

  var selectedTab = 0.obs;

  var courtFeeController = TextEditingController();
  var shuttlecockPriceController = TextEditingController();
  var shuttlecockCount = 0.obs;

  Rx<Session?> currentSession = Rx<Session?>(null);
  var attendanceList = <Attendance>[].obs;
  var extraFees = <ExtraFee>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedTab.value = tabController.index;
      }
    });

    _initData();
  }

  Future<void> _initData() async {
    db = await Get.find<DatabaseService>().db;

    if (Get.arguments != null && Get.arguments['id'] != null) {
      int sessionId = Get.arguments['id'];
      await loadSession(sessionId);
    }
  }

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

      courtFeeController.text =
          (session.courtPricePerHour * session.numberOfCourts * 2)
              .toString(); // Roughly
      shuttlecockPriceController.text = '28000';
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

    int feePerPerson = totalPresent > 0 ? (totalCost / totalPresent).ceil() : 0;
    // Round to nearest 1000
    feePerPerson = ((feePerPerson + 999) ~/ 1000) * 1000;

    await db.writeTxn(() async {
      // Create invoice
      final invoice = Invoice(
        courtFee: courtFee,
        shuttlecockCount: sCount,
        shuttlecockPrice: sPrice,
        maleFee: feePerPerson,
        femaleFee: feePerPerson,
      );
      await db.invoices.put(invoice);
      invoice.session.value = session;
      await invoice.session.save();

      // Update attendances
      for (var att in attendanceList) {
        if (att.attendanceStatus == AttendanceStatus.present) {
          att.feeToPay = feePerPerson;
          await db.attendances.put(att);
        }
      }

      // Update session status
      session.status = SessionStatus.checkout;
      session.checkoutTime = DateTime.now();
      await db.sessions.put(session);
    });

    await loadSession(session.id);
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
}
