import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/data/models/session.dart';

import 'session_detail_controller.dart';
import 'widgets/detail_segment_tab.dart';
import 'widgets/list_tab.dart';
import 'widgets/attendance_tab.dart';
import 'widgets/checkout_tab.dart';

class SessionDetailScreen extends GetView<SessionDetailController> {
  const SessionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFFF4F6F8),
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20.w,
                    color: const Color(0xFF14211A),
                  ),
                  onPressed: () => Get.back(),
                ),
                titleSpacing: 0,
                title: Text(
                  'S0810',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14211A),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      size: 24.w,
                      color: const Color(0xFF14211A),
                    ),
                    onPressed: () {},
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Obx(
                      () => DetailSegmentTab(
                        tabController: controller.tabController,
                        selectedIndex: controller.selectedTab.value,
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: Divider(thickness: 1)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Obx(() {
                    final session = controller.currentSession.value;
                    if (session == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final venue = session.venue.value;
                    String statusStr = 'Nháp';
                    if (session.status == SessionStatus.checkout)
                      statusStr = 'Quyết toán';
                    if (session.status == SessionStatus.closed)
                      statusStr = 'Đã chốt';

                    // Format date & time
                    int weekday = session.date.weekday;
                    String weekdayStr = weekday == 7 ? 'CN' : 'T${weekday + 1}';
                    String title =
                        'Cầu lông $weekdayStr ${session.date.day.toString().padLeft(2, '0')}/${session.date.month.toString().padLeft(2, '0')}';
                    String timeStr =
                        '$weekdayStr, ${session.date.day.toString().padLeft(2, '0')}/${session.date.month.toString().padLeft(2, '0')} · ${session.startTime}–${session.endTime}';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF14211A),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8ECEA),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Text(
                                statusStr,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF68776F),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: const Color(0xFF14211A),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20.w,
                              color: const Color(0xFF68776F),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    venue?.name ?? 'Chưa rõ sân',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF14211A),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    venue?.address ?? '',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF68776F),
                                    ),
                                  ),
                                  if (session.courtNumbers != null &&
                                      session.courtNumbers!.isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Sân số: ${session.courtNumbers}',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF146C43),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _ProgressBarDelegate(),
              ),
            ];
          },
          body: TabBarView(
            controller: controller.tabController,
            children: const [ListTab(), AttendanceTab(), CheckoutTab()],
          ),
        ),
      ),
    );
  }
}

class _ProgressBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 44.h;
  @override
  double get maxExtent => 44.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final controller = Get.find<SessionDetailController>();

    return Container(
      color: const Color(0xFFF4F6F8),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final memberCount = controller.attendanceList.length;
            final maxPlayers =
                controller.currentSession.value?.maxPlayers ?? 16;

            double progress = maxPlayers == 0 ? 0 : memberCount / maxPlayers;
            if (progress > 1.0) progress = 1.0;

            String label = '';
            if (controller.selectedTab.value == 0) {
              label = 'Điểm danh $memberCount/$maxPlayers';
            } else if (controller.selectedTab.value == 1) {
              label = 'Đã điểm danh $memberCount/$maxPlayers';
            } else {
              label = 'Đã điểm danh $memberCount/$maxPlayers';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF146C43),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 8.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E6E3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF146C43),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
