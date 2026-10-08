import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:host_babminton/core/text_styles.dart';
import 'package:host_babminton/modules/ui/calendar/calendar_controller.dart';

class SessionCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const SessionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed('/session-detail', arguments: data);
        if (Get.isRegistered<CalendarController>()) {
          Get.find<CalendarController>().loadSessions();
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE1E6E3), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date Badge
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECEA),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['weekday'],
                    style: AppTextStyles.labelMedium().copyWith(
                      color: const Color(0xFF68776F),
                    ),
                  ),
                  Text(
                    data['day'],
                    style: AppTextStyles.titleLarge().copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF14211A),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Middle Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'],
                    style: AppTextStyles.labelLarge().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/calendar/time.svg',
                        width: 15.w,
                        height: 15.h,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          data['time'],
                          style: AppTextStyles.labelLarge(
                            color: const Color(0xFF14211A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/calendar/location.svg',
                        width: 15.w,
                        height: 15.h,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          data['venue'],
                          style: AppTextStyles.labelLarge(
                            color: const Color(0xFF68776F),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Right Column (Status & Attendance)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusPill(data['status']),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 14.w,
                      color: const Color(0xFF14211A),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      data['attendance'],
                      style: AppTextStyles.labelLarge(
                        color: const Color(0xFF14211A),
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bgColor;
    Color textColor;
    bool hasCheck = false;

    switch (status) {
      case 'Quyết toán':
        bgColor = const Color(0xFFFF8A3D);
        textColor = const Color(0xFF14211A);
        break;
      case 'Đã chốt':
        bgColor = const Color(0xFF146C43);
        textColor = Colors.white;
        hasCheck = true;
        break;
      case 'Nháp':
      default:
        bgColor = const Color(0xFFE8ECEA);
        textColor = const Color(0xFF68776F);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.r), // Fully rounded pill
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasCheck) ...[
            Icon(Icons.check, size: 12.w, color: Colors.white),
            SizedBox(width: 4.w),
          ],
          Text(
            status,
            style: AppTextStyles.labelMedium().copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
