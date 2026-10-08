import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:host_babminton/core/text_styles.dart';

class CustomSegmentTab extends StatefulWidget {
  final ValueChanged<int> onChanged;

  const CustomSegmentTab({super.key, required this.onChanged});

  @override
  State<CustomSegmentTab> createState() => _CustomSegmentTabState();
}

class _CustomSegmentTabState extends State<CustomSegmentTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECEA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(children: [_buildTab(0, 'Sắp tới'), _buildTab(1, 'Đã qua')]),
    );
  }

  Widget _buildTab(int index, String text) {
    final isActive = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedIndex = index);
          widget.onChanged(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                )
              : null,
          child: Text(
            text,
            style: AppTextStyles.titleMedium16().copyWith(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? const Color(0xFF146C43)
                  : const Color(0xFF68776F),
            ),
          ),
        ),
      ),
    );
  }
}
