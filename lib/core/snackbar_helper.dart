import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/core/text_styles.dart';

class SnackbarHelper {
  static void showSuccess(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(isSuccess: true, title: title, message: message, duration: duration);
  }

  static void showError(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    _show(isSuccess: false, title: title, message: message, duration: duration);
  }

  static void showInfo(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(isSuccess: null, title: title, message: message, duration: duration);
  }

  static void _show({
    required bool? isSuccess,
    required String title,
    required String message,
    required Duration duration,
  }) {
    IconData icon;
    Color backgroundColor;

    if (isSuccess == true) {
      icon = Icons.check_circle_rounded;
      backgroundColor = Colors.green.shade600;
    } else if (isSuccess == false) {
      icon = Icons.error_rounded;
      backgroundColor = Colors.red.shade600;
    } else {
      icon = Icons.info_outline_rounded;
      backgroundColor = Colors.blue.shade600;
    }

    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.labelLarge().copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: AppTextStyles.titleSmall2().copyWith(color: Colors.white),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      borderRadius: 12.r,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      duration: duration,
      animationDuration: const Duration(milliseconds: 1000),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.4),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
