import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/core/text_styles.dart';
import 'calendar_controller.dart';
import 'widgets/custom_segment_tab.dart';
import 'widgets/month_header.dart';
import 'widgets/session_card.dart';

class CalendarScreen extends GetView<CalendarController> {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lịch', style: AppTextStyles.titleLarge()),
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      size: 28.w,
                      color: const Color(0xFF14211A),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Segmented Control
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomSegmentTab(onChanged: controller.switchTab),
            ),
            SizedBox(height: 16.h),
            // List
            Expanded(
              child: Obx(() {
                final data = controller.selectedTab.value == 0
                    ? controller.upcomingSessions
                    : controller.pastSessions;

                if (data.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    bottom: 100.h,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final group = data[index];
                    final items = group['items'] as List;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MonthHeader(title: group['month'] as String),
                        ...items.map(
                          (item) =>
                              SessionCard(data: item as Map<String, dynamic>),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF146C43),
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        onPressed: () {
          Get.toNamed('/create-session');
        },
        icon: Icon(Icons.add, color: Colors.white, size: 20.w),
        label: Text('Tạo buổi', style: AppTextStyles.bodyLarge()),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64.w,
            color: const Color(0xFF68776F).withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có buổi nào',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14211A),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tạo buổi đầu tiên để bắt đầu theo dõi',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF68776F)),
          ),
        ],
      ),
    );
  }
}
