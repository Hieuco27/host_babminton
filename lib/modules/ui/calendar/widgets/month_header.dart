import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:host_babminton/core/text_styles.dart';

class MonthHeader extends StatelessWidget {
  final String title;
  const MonthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Text(
        title,
        style: AppTextStyles.bodyMedium().copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
