import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/data/models/attendance.dart';
import '../session_detail_controller.dart';

class AttendanceTab extends GetView<SessionDetailController> {
  const AttendanceTab({super.key});

  Future<void> _updateStatus(Attendance attendance, AttendanceStatus status) async {
    await controller.db.writeTxn(() async {
      attendance.attendanceStatus = status;
      await controller.db.attendances.put(attendance);
    });
    // Trigger reload
    final id = controller.currentSession.value?.id;
    if (id != null) {
      await controller.loadSession(id);
    }
  }

  Future<void> _markAllPresent() async {
    await controller.db.writeTxn(() async {
      for (var att in controller.attendanceList) {
        if (att.attendanceStatus == AttendanceStatus.notVoted) {
          att.attendanceStatus = AttendanceStatus.present;
          await controller.db.attendances.put(att);
        }
      }
    });
    final id = controller.currentSession.value?.id;
    if (id != null) {
      await controller.loadSession(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final members = controller.attendanceList;

      int presentCount = members.where((m) => m.attendanceStatus == AttendanceStatus.present).length;
      int absentCount = members.where((m) => m.attendanceStatus == AttendanceStatus.absent).length;
      int votedCount = presentCount + absentCount;

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildCounterCard(votedCount, presentCount, absentCount),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: members.any((m) => m.attendanceStatus == AttendanceStatus.notVoted)
                          ? _markAllPresent
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8ECEA),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Có mặt tất cả',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF14211A),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE1E6E3),
                      ),
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return _buildAttendanceRow(member);
                      },
                    ),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCounterCard(int voted, int present, int absent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE1E6E3)),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(child: _buildCounterItem(voted.toString(), 'Đã vote')),
          Container(width: 1, height: 40.h, color: const Color(0xFFE1E6E3)),
          Expanded(child: _buildCounterItem(present.toString(), 'Có mặt')),
          Container(width: 1, height: 40.h, color: const Color(0xFFE1E6E3)),
          Expanded(child: _buildCounterItem(absent.toString(), 'Vắng')),
        ],
      ),
    );
  }

  Widget _buildCounterItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF14211A),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF68776F),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceRow(Attendance attendance) {
    final isPresent = attendance.attendanceStatus == AttendanceStatus.present;
    final isAbsent = attendance.attendanceStatus == AttendanceStatus.absent;
    final isMale = attendance.isMale;
    final name = attendance.member.value?.name ?? attendance.guestName;
    final gender = isMale ? 'Nam' : 'Nữ';

    return Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14211A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isMale ? const Color(0xFFDCEAFF) : const Color(0xFFFFE1ED),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isMale ? const Color(0xFF1459B3) : const Color(0xFFB0245E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Row(
            children: [
              _buildAttendanceButton(
                text: 'Có mặt',
                icon: Icons.check,
                isSelected: isPresent,
                selectedColor: const Color(0xFF146C43),
                selectedTextColor: Colors.white,
                onTap: () => _updateStatus(attendance, AttendanceStatus.present),
              ),
              SizedBox(width: 8.w),
              _buildAttendanceButton(
                text: 'Vắng',
                icon: Icons.close,
                isSelected: isAbsent,
                selectedColor: const Color(0xFFFFE8DF),
                selectedTextColor: const Color(0xFFC8431B),
                onTap: () => _updateStatus(attendance, AttendanceStatus.absent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton({
    required String text,
    required IconData icon,
    required bool isSelected,
    required Color selectedColor,
    required Color selectedTextColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w, // reduced slightly to fit smaller screens
        height: 44.h,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: isSelected ? null : Border.all(color: const Color(0xFFE1E6E3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              Icon(icon, size: 16.w, color: selectedTextColor),
              SizedBox(width: 4.w),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? selectedTextColor : const Color(0xFF14211A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
