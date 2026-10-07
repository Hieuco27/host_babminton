import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:host_babminton/data/models/extra_fee.dart';
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
            left: 16.w,
            right: 16.w,
            top: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thêm khoản khác',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF14211A),
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
                        style: TextStyle(
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
                    style: TextStyle(
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

      return Stack(
        children: [
          CustomScrollView(
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
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF14211A),
                              ),
                            ),
                            Text(
                              '$total đ',
                              style: TextStyle(
                                fontSize: 18.sp,
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
          if (!isCheckout)
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
                  height: 56.h,
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
                      style: TextStyle(
                        fontSize: 17.sp,
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi phí',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14211A),
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'Tiền sân',
            controller: controller.courtFeeController,
            keyboardType: TextInputType.number,
            suffixIcon: _buildSuffix('đ'),
            readOnly: isCheckout,
          ),
          SizedBox(height: 16.h),
          Text(
            'Số quả cầu',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF68776F),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              if (!isCheckout)
                _buildStepperBtn(Icons.remove, controller.decrementShuttlecock),
              SizedBox(
                width: 48.w,
                child: Obx(
                  () => Text(
                    '${controller.shuttlecockCount.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
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
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'Đơn giá mỗi quả',
            controller: controller.shuttlecockPriceController,
            keyboardType: TextInputType.number,
            suffixIcon: _buildSuffix('đ'),
            readOnly: isCheckout,
          ),
          SizedBox(height: 12.h),
          Text(
            'Tiền cầu: $shuttlecockTotal đ',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14211A),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khoản khác',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF14211A),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
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
            style: TextStyle(fontSize: 15.sp, color: const Color(0xFF68776F)),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECEA),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: const Color(0xFF14211A)),
      ),
    );
  }
}
