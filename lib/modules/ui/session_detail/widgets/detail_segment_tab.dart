import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailSegmentTab extends StatelessWidget {
  final TabController tabController;
  final int selectedIndex;

  const DetailSegmentTab({
    super.key,
    required this.tabController,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECEA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          _buildTab(0, 'Danh sách'),
          _buildTab(1, 'Điểm danh'),
          _buildTab(2, 'Quyết toán'),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String text) {
    final isActive = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => tabController.animateTo(index),
        child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                )
              : const BoxDecoration(color: Colors.transparent),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
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
