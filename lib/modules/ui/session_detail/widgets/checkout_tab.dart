import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:host_babminton/data/models/extra_fee.dart';
import 'package:host_babminton/core/text_styles.dart';
import 'package:host_babminton/data/models/invoice.dart';
import 'package:host_babminton/data/models/attendance.dart';
import 'package:intl/intl.dart';
import '../session_detail_controller.dart';
import '../../create_session/widgets/custom_text_field.dart';

class CheckoutTab extends GetView<SessionDetailController> {
  const CheckoutTab({super.key});

  void _showAddExtraFeeSheet(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 8.w,
            right: 8.w,
            top: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thêm khoản khác',
                style: AppTextStyles.titleMediumBlack().copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                label: 'Tên khoản phí',
                controller: nameController,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                label: 'Số tiền',
                controller: amountController,
                keyboardType: TextInputType.number,
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'đ',
                        style: AppTextStyles.bodyMedium().copyWith(
                          fontSize: 15.sp,
                          color: const Color(0xFF68776F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF146C43),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final amount =
                        int.tryParse(
                          amountController.text.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          ),
                        ) ??
                        0;
                    if (name.isNotEmpty && amount > 0) {
                      final session = controller.currentSession.value;
                      if (session != null) {
                        await controller.db.writeTxn(() async {
                          final fee = ExtraFee(name: name, amount: amount);
                          await controller.db.extraFees.put(fee);
                          fee.session.value = session;
                          await fee.session.save();
                        });
                        await controller.loadSession(session.id);
                      }
                      Get.back();
                    }
                  },
                  child: Text(
                    'Thêm',
                    style: AppTextStyles.titleMediumBlack().copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.currentSession.value;
      if (session == null) return const SizedBox();

      int courtFee =
          int.tryParse(
            controller.courtFeeController.text.replaceAll(
              RegExp(r'[^0-9]'),
              '',
            ),
          ) ??
          0;
      int sPrice =
          int.tryParse(
            controller.shuttlecockPriceController.text.replaceAll(
              RegExp(r'[^0-9]'),
              '',
            ),
          ) ??
          0;
      int sCount = controller.shuttlecockCount.value;

      int sTotal = sPrice * sCount;
      int extraTotal = controller.extraFees.fold(
        0,
        (sum, item) => sum + item.amount,
      );
      int total = courtFee + sTotal + extraTotal;

      bool isCheckout =
          session.status == SessionStatus.checkout ||
          session.status == SessionStatus.closed;

      if (isCheckout && controller.currentInvoice.value != null) {
        return Stack(
          children: [
            _buildCheckoutResult(context, controller.currentInvoice.value!),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 16.h,
                  bottom: MediaQuery.of(context).padding.bottom + 16.h,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white,
                      Colors.white,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEBA500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            String formatK(int value) => (value % 1000 == 0)
                                ? '${value ~/ 1000}k'
                                : '${value / 1000}k';

                            final invoice = controller.currentInvoice.value!;
                            int presentMales = controller.attendanceList
                                .where(
                                  (a) =>
                                      a.attendanceStatus ==
                                          AttendanceStatus.present &&
                                      a.isMale,
                                )
                                .length;
                            int presentFemales = controller.attendanceList
                                .where(
                                  (a) =>
                                      a.attendanceStatus ==
                                          AttendanceStatus.present &&
                                      !a.isMale,
                                )
                                .length;
                            int totalPresent = presentMales + presentFemales;

                            int sTotal =
                                invoice.shuttlecockPrice *
                                invoice.shuttlecockCount;
                            int totalExtras = controller.extraFees.fold(
                              0,
                              (sum, item) => sum + item.amount,
                            );
                            int totalCost =
                                invoice.courtFee + sTotal + totalExtras;

                            String courtFeeK = formatK(
                              invoice.courtFee + totalExtras,
                            );
                            String sPriceK = formatK(invoice.shuttlecockPrice);
                            String totalCostK = formatK(totalCost);
                            String maleFeeK = formatK(invoice.maleFee);
                            String femaleFeeK = formatK(invoice.femaleFee);

                            String copyText =
                                'Hôm nay tiền sân hết $courtFeeK + ${invoice.shuttlecockCount} X $sPriceK cầu / $totalPresent = $totalCostK\nNam $maleFeeK\nNữ $femaleFeeK';

                            Clipboard.setData(ClipboardData(text: copyText));

                            Get.snackbar(
                              'Đã copy',
                              'Nội dung chia tiền đã được copy',
                              backgroundColor: const Color(0xFF146C43),
                              colorText: Colors.white,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.copy,
                                size: 18.w,
                                color: const Color(0xFF14211A),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Copy ',
                                style: AppTextStyles.titleSmall3().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF14211A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8ECEA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            controller.markAllAsPaid();
                            Get.snackbar(
                              'Thành công',
                              'Đã đánh dấu thu đủ tiền của tất cả thành viên',
                              backgroundColor: const Color(0xFF146C43),
                              colorText: Colors.white,
                            );
                          },
                          child: Text(
                            'Đã thu đủ',
                            style: AppTextStyles.titleMediumBlack().copyWith(
                              color: const Color(0xFF68776F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      return Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 8.w,
                    right: 8.w,
                    top: 16.h,
                    bottom: 120.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCostCard(context, sTotal, isCheckout),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF146C43,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng cộng',
                              style: AppTextStyles.titleMediumBlack().copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$total đ',
                              style: AppTextStyles.titleMediumBlack().copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF146C43),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                bottom: MediaQuery.of(context).padding.bottom + 16.h,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white,
                    Colors.white,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
              child: SizedBox(
                height: 48.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF146C43),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    controller.checkout();
                    Get.snackbar(
                      'Thành công',
                      'Đã chốt hóa đơn và chia tiền',
                      backgroundColor: const Color(0xFF146C43),
                      colorText: Colors.white,
                    );
                  },
                  child: Text(
                    'Chốt hóa đơn',
                    style: AppTextStyles.titleMediumBlack().copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCostCard(
    BuildContext context,
    int shuttlecockTotal,
    bool isCheckout,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi phí',
            style: AppTextStyles.titleMediumBlack().copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            label: 'Tiền sân',
            controller: controller.courtFeeController,
            keyboardType: TextInputType.number,
            suffixIcon: _buildSuffix('đ'),
            readOnly: isCheckout,
          ),
          SizedBox(height: 12.h),
          Text(
            'Số quả cầu',
            style: AppTextStyles.labelMedium().copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              if (!isCheckout)
                _buildStepperBtn(Icons.remove, controller.decrementShuttlecock),
              SizedBox(
                width: 40.w,

                child: Obx(
                  () => Text(
                    '${controller.shuttlecockCount.value}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge().copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF14211A),
                    ),
                  ),
                ),
              ),
              if (!isCheckout)
                _buildStepperBtn(Icons.add, controller.incrementShuttlecock),
            ],
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            label: 'Đơn giá mỗi quả',
            controller: controller.shuttlecockPriceController,
            keyboardType: TextInputType.number,
            suffixIcon: _buildSuffix('đ'),
            readOnly: isCheckout,
          ),
          SizedBox(height: 16.h),
          Text(
            'Tiền cầu: $shuttlecockTotal đ',
            style: AppTextStyles.labelLarge().copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khoản khác',
                  style: AppTextStyles.labelLarge().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                ...controller.extraFees.map((fee) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fee.name),
                        Text(
                          '${fee.amount} đ',
                          style: AppTextStyles.bodyMedium().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                if (!isCheckout)
                  InkWell(
                    onTap: () => _showAddExtraFeeSheet(context),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD5DBD8),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: const Color(0xFF146C43),
                            size: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Thêm khoản khác',
                            style: AppTextStyles.labelLarge().copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF146C43),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuffix(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: AppTextStyles.bodyMedium().copyWith(
              fontSize: 15.sp,
              color: const Color(0xFF68776F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECEA),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: const Color(0xFF14211A)),
      ),
    );
  }

  Widget _buildCheckoutResult(BuildContext context, Invoice invoice) {
    int presentMales = controller.attendanceList
        .where(
          (a) => a.attendanceStatus == AttendanceStatus.present && a.isMale,
        )
        .length;
    int presentFemales = controller.attendanceList
        .where(
          (a) => a.attendanceStatus == AttendanceStatus.present && !a.isMale,
        )
        .length;
    int totalPresent = presentMales + presentFemales;
    int paidCount = controller.attendanceList
        .where(
          (a) =>
              a.attendanceStatus == AttendanceStatus.present &&
              a.paymentStatus == PaymentStatus.paid,
        )
        .length;

    double progress = totalPresent > 0 ? paidCount / totalPresent : 0;

    int sTotal = invoice.shuttlecockPrice * invoice.shuttlecockCount;
    int totalExtras = controller.extraFees.fold(
      0,
      (sum, item) => sum + item.amount,
    );
    int totalCost = invoice.courtFee + sTotal + totalExtras;
    final NumberFormat formatter = NumberFormat('#,###', 'vi_VN');

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 16.h,
              bottom: 120.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A603E),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng sân + cầu',
                        style: AppTextStyles.bodyMedium().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${formatter.format(totalCost)}đ',
                        style: AppTextStyles.titleLarge().copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sân ${formatter.format(invoice.courtFee)}đ + Cầu ${formatter.format(sTotal)}đ',
                        style: AppTextStyles.bodyMedium().copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F4FF),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFD6EFFF)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nam',
                              style: AppTextStyles.titleSmall3().copyWith(
                                color: const Color(0xFF005A9E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${formatter.format(invoice.maleFee)}đ',
                              style: AppTextStyles.bodyMedium().copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF005A9E),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '× $presentMales người',
                              style: AppTextStyles.bodyMedium().copyWith(
                                color: const Color(0xFF005A9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE6EA),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFFCD6DC)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nữ',
                              style: AppTextStyles.titleSmall3().copyWith(
                                color: const Color(0xFF9E003D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${formatter.format(invoice.femaleFee)}đ',
                              style: AppTextStyles.bodyMedium().copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF9E003D),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '× $presentFemales người',
                              style: AppTextStyles.bodyMedium().copyWith(
                                color: const Color(0xFF9E003D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F8),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16.w,
                        color: const Color(0xFF68776F),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          'Quy tắc: nếu phí bình quân > 45k thì Nữ tối đa 45k, Nam chia phần còn lại; nếu ≤ 45k thì chia đều.',
                          style: AppTextStyles.labelMedium().copyWith(
                            color: const Color(0xFF68776F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFD5DBD8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đã thu: $paidCount/$totalPresent người',
                        style: AppTextStyles.titleMediumBlack().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8ECEA),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF146C43),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
