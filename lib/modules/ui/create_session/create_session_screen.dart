import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/core/text_styles.dart';
import 'package:intl/intl.dart';
import 'create_session_controller.dart';
import 'widgets/section_card.dart';
import 'widgets/custom_text_field.dart';

class CreateSessionScreen extends GetView<CreateSessionController> {
  const CreateSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF4F6F8),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color(0xFF14211A),
            size: 22.w,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Text('Tạo buổi chơi', style: AppTextStyles.titleMediumBlack()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 8.h,
          bottom: 24.h + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            _buildWhenCard(context),
            _buildWhereCard(),
            _buildHowMuchCard(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).padding.bottom + 16.h,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F8),
          border: Border(
            top: BorderSide(color: const Color(0xFFE5E9E7), width: 1.h),
          ),
        ),
        child: SizedBox(
          height: 52.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF146C43),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 0,
            ),
            onPressed: controller.saveSession,
            child: Text(
              'Lưu buổi chơi',
              style: AppTextStyles.titleMediumAppBar(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWhenCard(BuildContext context) {
    return SectionCard(
      title: 'Khi nào',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => CustomTextField(
              label: 'Ngày',
              isRequired: true,
              readOnly: true,
              placeholder: 'Chọn ngày',
              controller: TextEditingController(
                text: controller.selectedDate.value != null
                    ? DateFormat(
                        'dd/MM/yyyy',
                      ).format(controller.selectedDate.value!)
                    : '',
              ),
              suffixIcon: Icon(
                Icons.calendar_today,
                size: 20.w,
                color: const Color(0xFF68776F),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) controller.selectedDate.value = date;
              },
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(
                  () => CustomTextField(
                    label: 'Giờ bắt đầu',
                    isRequired: true,
                    readOnly: true,
                    placeholder: 'Chọn giờ',
                    controller: TextEditingController(
                      text: controller.startTime.value != null
                          ? '${controller.startTime.value!.hour.toString().padLeft(2, '0')}:${controller.startTime.value!.minute.toString().padLeft(2, '0')}'
                          : '',
                    ),
                    suffixIcon: Icon(
                      Icons.access_time,
                      size: 20.w,
                      color: const Color(0xFF68776F),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime:
                            controller.startTime.value ??
                            const TimeOfDay(hour: 19, minute: 0),
                      );
                      if (time != null) controller.startTime.value = time;
                    },
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(
                  () => CustomTextField(
                    label: 'Giờ kết thúc',
                    isRequired: true,
                    readOnly: true,
                    errorText: controller.timeError.value,
                    placeholder: 'Chọn giờ',
                    controller: TextEditingController(
                      text: controller.endTime.value != null
                          ? '${controller.endTime.value!.hour.toString().padLeft(2, '0')}:${controller.endTime.value!.minute.toString().padLeft(2, '0')}'
                          : '',
                    ),
                    suffixIcon: Icon(
                      Icons.access_time,
                      size: 20.w,
                      color: const Color(0xFF68776F),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime:
                            controller.endTime.value ??
                            const TimeOfDay(hour: 21, minute: 0),
                      );
                      if (time != null) controller.endTime.value = time;
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(
            () => Text(
              'Mã buổi: ${controller.sessionCode}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF68776F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhereCard() {
    return SectionCard(
      title: 'Ở đâu',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => CustomTextField(
              label: 'Tên địa điểm',
              isRequired: true,
              placeholder: 'Nhập tên sân',
              controller: controller.venueNameController,
              errorText: controller.venueError.value,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(
              controller.savedVenues.length,
              (index) => Obx(() {
                final isSelected = controller.selectedVenueIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectVenue(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF146C43)
                          : const Color(0xFFE8ECEA),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      controller.savedVenues[index]['name']!,
                      style:
                          AppTextStyles.labelLarge(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF14211A),
                          ).copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 4.h),
          CustomTextField(
            label: 'Địa chỉ',
            placeholder: 'Ví dụ: 120 Định Công',
            controller: controller.addressController,
          ),
        ],
      ),
    );
  }

  Widget _buildHowMuchCard() {
    return SectionCard(
      title: 'Bao nhiêu',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Số sân',
                  isRequired: true,
                  placeholder: '2',

                  controller: controller.numCourtsController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.numCourtsController.text = v,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextField(
                  label: 'Số chỗ tối đa',
                  isRequired: true,
                  placeholder: '16',
                  controller: controller.maxPlayersController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'Sân số (Tùy chọn)',
            placeholder: 'Ví dụ: 1, 2, 3...',
            controller: controller.courtNumbersController,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'Giá sân/giờ',
            isRequired: true,
            placeholder: '240.000',
            controller: controller.pricePerCourtController,
            keyboardType: TextInputType.number,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'đ/giờ',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF68776F),
                    ),
                  ),
                ],
              ),
            ),
            onChanged: (value) {
              // Simple thousands formatting could be added here
            },
          ),
          SizedBox(height: 8.h),
          Text(
            'Tính cho mỗi sân, bội số của 1.000 đ',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF68776F)),
          ),
          SizedBox(height: 16.h),

          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF146C43).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Obx(() {
              // A small hack to trigger obx when inputs change, normally we would add listeners.
              final courts = controller.numCourtsController.text;
              final price = controller.pricePerCourtController.text;
              return Text(
                'Tạm tính tiền sân: $courts sân × ${controller.totalHours} giờ × $priceđ = ${NumberFormat.decimalPattern('vi').format(controller.totalCourtCost)}đ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF146C43),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
