import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:host_babminton/core/app_colors.dart';
import 'package:host_babminton/core/text_styles.dart';

class InfoPopup extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final double? width;
  final double? borderRadius;
  final bool barrierDismissible;
  final Widget? icon;
  const InfoPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onButtonPressed,
    this.backgroundColor,
    this.buttonColor,
    this.buttonTextColor,
    this.width,
    this.borderRadius,
    this.barrierDismissible = false,
    this.icon,
  });
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    Color? backgroundColor,
    Color? buttonColor,
    Color? buttonTextColor,
    double? width,
    double? borderRadius,
    bool barrierDismissible = true,
    Widget? icon,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => InfoPopup(
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        backgroundColor: backgroundColor,
        buttonColor: buttonColor,
        buttonTextColor: buttonTextColor,
        width: width,
        borderRadius: borderRadius,
        barrierDismissible: barrierDismissible,
        icon: icon,
      ),
    );
  }

  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Continue',
    VoidCallback? onButtonPressed,
    Widget? icon,
  }) {
    return show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      buttonColor: AppColors.gradientEnd,
      buttonTextColor: Colors.black,
      onButtonPressed: onButtonPressed,
    );
  }

  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    Widget? icon,
  }) {
    return show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      buttonColor: AppColors.primary3,
      buttonTextColor: Colors.white,
      onButtonPressed: onButtonPressed,
      icon: icon ?? const Icon(Icons.error, color: Colors.red, size: 48),
    );
  }

  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    Color? confirmColor,
    Color? confirmTextColor,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Container(
            width: 280.w,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null) ...[icon, SizedBox(height: 6.h)],
                Text(title, style: AppTextStyles.titleMedium()),
                SizedBox(height: 12.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    // Nút Hủy
                    Expanded(
                      child: SizedBox(
                        height: 40.h,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            cancelText,
                            style: AppTextStyles.labelLarge().copyWith(
                              color: AppColors.primary3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    // Nút Xác nhận
                    Expanded(
                      child: SizedBox(
                        height: 40.h,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: confirmColor ?? AppColors.primary3,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            confirmText,
                            style: AppTextStyles.labelLarge2().copyWith(
                              color: confirmTextColor ?? Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Template sẵn cho đăng xuất
  static Future<bool?> showLogout(
    BuildContext context, {
    VoidCallback? onConfirmed,
  }) async {
    final result = await showConfirm(
      context,
      title: 'Đăng xuất',
      message: 'Bạn có chắc chắn muốn đăng xuất không?',
      confirmText: 'Đăng xuất',
      cancelText: 'Hủy',
      confirmColor: Colors.red,
    );

    if (result == true) onConfirmed?.call();
    return result;
  }

  // Template sẵn cho quên thiết bị
  static Future<bool?> showForgetDevice(
    BuildContext context, {
    required String deviceName,
    Future<void> Function()? onConfirmed,
  }) async {
    final result = await showConfirm(
      context,
      title: 'Quên thiết bị?',
      message: 'Thiết bị "$deviceName" sẽ bị xóa khỏi danh sách đã kết nối.',
      confirmText: 'Quên',
      cancelText: 'Hủy',
      confirmColor: Colors.red,
    );

    if (result == true) await onConfirmed?.call();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: barrierDismissible,
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Container(
          width: width ?? 320.w,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                message,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onButtonPressed?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor ?? AppColors.primary3,
                    foregroundColor: buttonTextColor ?? Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
