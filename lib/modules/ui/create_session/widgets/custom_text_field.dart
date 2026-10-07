import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextEditingController? controller;
  final String? placeholder;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.controller,
    this.placeholder,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF68776F),
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: const Color(0xFFC8431B),
                    fontSize: 13.sp,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF14211A),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF68776F).withValues(alpha: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: errorText != null && errorText!.isNotEmpty
                    ? const Color(0xFFC8431B)
                    : const Color(0xFFD5DBD8),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: errorText != null && errorText!.isNotEmpty
                    ? const Color(0xFFC8431B)
                    : const Color(0xFFD5DBD8),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: errorText != null && errorText!.isNotEmpty
                    ? const Color(0xFFC8431B)
                    : const Color(0xFF146C43),
                width: 1.5,
              ),
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: Text(
              errorText!,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFFC8431B)),
            ),
          ),
      ],
    );
  }
}
