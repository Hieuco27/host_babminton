import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/core/text_styles.dart';
import 'package:host_babminton/data/models/member.dart';
import 'package:host_babminton/data/models/attendance.dart';
import 'package:isar/isar.dart';
import '../session_detail_controller.dart';

class ListTab extends StatefulWidget {
  const ListTab({super.key});

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  final ScrollController _scrollController = ScrollController();
  final SessionDetailController controller =
      Get.find<SessionDetailController>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _deleteAttendance(Attendance attendance) async {
    await controller.db.writeTxn(() async {
      await controller.db.attendances.delete(attendance.id);
    });
    if (controller.currentSession.value != null) {
      await controller.loadSession(controller.currentSession.value!.id);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xoá ${attendance.member.value?.name ?? ""}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final members = controller.attendanceList;

      if (members.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(child: _buildTableHeader()),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final attendance = members[index];
                      final memberName = attendance.member.value?.name ?? '';
                      final isMale = attendance.isMale;
                      final isPaid =
                          attendance.paymentStatus == PaymentStatus.paid;

                      return Dismissible(
                        key: ValueKey(attendance.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 24.w),
                          color: Colors.white,
                          child: Container(
                            width: 72.w,
                            height: 56.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC8431B),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 24.w,
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          _deleteAttendance(attendance);
                        },
                        child: Container(
                          height: 45.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE1E6E3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 16.w),
                              SizedBox(
                                width: 20.w,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF14211A),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3EFD9),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      memberName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF14211A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: _buildGenderPill(
                                    isMale ? 'Nam' : 'Nữ',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 88.w,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () => controller.togglePaymentStatus(
                                      attendance,
                                    ),
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: _buildStatusPill(
                                      isPaid ? 'Đã TT' : 'Chưa TT',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 28.w),
                            ],
                          ),
                        ),
                      );
                    }, childCount: members.length),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 12.h,
              bottom: MediaQuery.of(context).padding.bottom + 12.h,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE1E6E3))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildAddButton(
                        text: '+ Thêm Nam',
                        borderColor: const Color(0xFFDCEAFF),
                        textColor: const Color(0xFF1459B3),
                        onTap: () => _showAddMemberSheet(context, true),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildAddButton(
                        text: '+ Thêm Nữ',
                        borderColor: const Color(0xFFFFE1ED),
                        textColor: const Color(0xFFB0245E),
                        onTap: () => _showAddMemberSheet(context, false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_tennis,
              size: 64.w,
              color: const Color(0xFFE1E6E3),
            ),
            SizedBox(height: 16.h),
            Text(
              'Chưa có ai trong buổi này',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF14211A),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Thêm thành viên đã vote để bắt đầu',
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF68776F)),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 140.w,
                  child: _buildAddButton(
                    text: '+ Thêm Nam',
                    borderColor: const Color(0xFFDCEAFF),
                    textColor: const Color(0xFF1459B3),
                    onTap: () => _showAddMemberSheet(context, true),
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 140.w,
                  child: _buildAddButton(
                    text: '+ Thêm Nữ',
                    borderColor: const Color(0xFFFFE1ED),
                    textColor: const Color(0xFFB0245E),
                    onTap: () => _showAddMemberSheet(context, false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFFFE08A),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 48.h,
      child: Row(
        children: [
          SizedBox(
            width: 36.w,
            child: Text('STT', style: _headerStyle),
          ),
          SizedBox(width: 12.w),
          Expanded(flex: 3, child: Text('Tên', style: _headerStyle)),
          SizedBox(width: 8.w),
          Expanded(
            flex: 2,
            child: Text(
              'Giới tính',
              textAlign: TextAlign.center,
              style: _headerStyle,
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Text(
          //     'Tiền',
          //     textAlign: TextAlign.center,
          //     style: _headerStyle,
          //   ),
          // ),
          SizedBox(
            width: 88.w,
            child: Text(
              'Trạng thái',
              textAlign: TextAlign.center,
              style: _headerStyle,
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  final _headerStyle = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF14211A),
  );

  Widget _buildGenderPill(String gender) {
    final isMale = gender == 'Nam';
    return Container(
      width: 48.w,
      height: 28.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: isMale ? const Color(0xFFDCEAFF) : const Color(0xFFFFE1ED),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        gender,
        style: AppTextStyles.titleSmall2(
          color: isMale ? const Color(0xFF1459B3) : const Color(0xFFB0245E),
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    final isPaid = status == 'Đã TT';
    return Container(
      width: 76.w,
      height: 30.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isPaid ? const Color(0xFF146C43) : const Color(0xFFE8ECEA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        status,
        style: AppTextStyles.titleSmall3(
          color: isPaid ? Colors.white : const Color(0xFF68776F),
        ),
      ),
    );
  }

  Widget _buildAddButton({
    required String text,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(text, style: AppTextStyles.titleMedium(color: textColor)),
      ),
    );
  }

  void _showAddMemberSheet(BuildContext context, bool initialIsMale) {
    int maxPlayers = controller.currentSession.value?.maxPlayers ?? 16;
    if (controller.attendanceList.length >= maxPlayers) {
      Get.dialog(
        AlertDialog(
          title: const Text('Đã đủ chỗ'),
          content: Text('Đã đủ $maxPlayers chỗ. Bạn vẫn muốn thêm?'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
            TextButton(
              onPressed: () {
                Get.back();
                _openActualSheet(context, initialIsMale);
              },
              child: const Text('Vẫn thêm'),
            ),
          ],
        ),
      );
    } else {
      _openActualSheet(context, initialIsMale);
    }
  }

  void _openActualSheet(BuildContext context, bool initialIsMale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _AddMemberSheet(
            initialIsMale: initialIsMale,
            controller: controller,
          ),
        );
      },
    );
  }
}

class _AddMemberSheet extends StatefulWidget {
  final bool initialIsMale;
  final SessionDetailController controller;

  const _AddMemberSheet({
    required this.initialIsMale,
    required this.controller,
  });

  @override
  State<_AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<_AddMemberSheet> {
  late bool isMale;
  final textController = TextEditingController();
  List<Member> savedMembers = [];

  @override
  void initState() {
    super.initState();
    isMale = widget.initialIsMale;
    _loadSavedMembers();
  }

  Future<void> _loadSavedMembers() async {
    final members = await widget.controller.db.members.where().findAll();
    setState(() {
      savedMembers = members;
    });
  }

  Future<void> _addMember(String name, bool isMale) async {
    if (widget.controller.currentSession.value == null) return;
    final session = widget.controller.currentSession.value!;

    await widget.controller.db.writeTxn(() async {
      // Find or create member
      var member = await widget.controller.db.members
          .filter()
          .nameEqualTo(name)
          .findFirst();
      if (member == null) {
        member = Member(name: name, isMale: isMale);
        await widget.controller.db.members.put(member);
      }

      // Create attendance
      final attendance = Attendance(isMale: isMale);

      await widget.controller.db.attendances.put(attendance);
      attendance.member.value = member;
      attendance.session.value = session;
      await attendance.member.save();
      await attendance.session.save();
    });

    await widget.controller.loadSession(session.id);
    Get.back();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm $name'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E6E3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'Thêm ${isMale ? "Nam" : "Nữ"}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF14211A),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ghi nhận thành viên đã vote tham gia',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF68776F),
                  ),
                ),
                Obx(
                  () => Text(
                    '${widget.controller.attendanceList.length}/${widget.controller.currentSession.value?.maxPlayers ?? 16} chỗ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF14211A),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Tên',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF14211A),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 48.h,
              child: TextField(
                controller: textController,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Nhập tên',
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF68776F).withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFD5DBD8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFD5DBD8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFF146C43)),
                  ),
                ),
                onChanged: (val) => setState(() {}),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Hội viên đã lưu',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF68776F)),
            ),
            SizedBox(height: 12.h),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 140.h),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: savedMembers
                      .where(
                        (m) =>
                            m.isMale == isMale &&
                            (textController.text.isEmpty ||
                                m.name.toLowerCase().contains(
                                  textController.text.toLowerCase(),
                                )),
                      )
                      .map(
                        (m) => GestureDetector(
                          onTap: () {
                            textController.text = m.name;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F6F8),
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: Text(
                              m.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF68776F),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF146C43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                onPressed: textController.text.isNotEmpty
                    ? () => _addMember(textController.text, isMale)
                    : null,
                child: Text(
                  'Thêm',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
