import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:host_babminton/core/text_styles.dart';

import 'session_detail_controller.dart';
import 'widgets/detail_segment_tab.dart';
import 'widgets/list_tab.dart';
import 'widgets/attendance_tab.dart';
import 'widgets/checkout_tab.dart';

class SessionDetailScreen extends GetView<SessionDetailController> {
  const SessionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        resizeToAvoidBottomInset: false,
        body: RepaintBoundary(
          key: controller.repaintBoundaryKey,
          child: SafeArea(
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
                    title: Obx(
                      () => Text(
                        controller.currentSession.value?.code ?? '',
                        style: AppTextStyles.titleLarge().copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF14211A),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          size: 24.w,
                          color: const Color(0xFF14211A),
                        ),
                        onPressed: () => controller.captureFullList(context),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(40.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Obx(() {
                        final session = controller.currentSession.value;
                        if (session == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final venue = session.venue.value;
                        String statusStr = 'Nháp';
                        if (session.status == SessionStatus.checkout)
                          statusStr = 'Quyết toán';
                        if (session.status == SessionStatus.closed)
                          statusStr = 'Đã chốt';

                        // Format date & time
                        int weekday = session.date.weekday;
                        String weekdayStr = weekday == 7
                            ? 'CN'
                            : 'T${weekday + 1}';
                        String timeStr =
                            '$weekdayStr, ${session.date.day.toString().padLeft(2, '0')}/${session.date.month.toString().padLeft(2, '0')} · ${session.startTime} – ${session.endTime}';

                        return Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: const Color(0xFFE8ECEA)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      timeStr,
                                      style: AppTextStyles.bodyMedium()
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8ECEA),
                                      borderRadius: BorderRadius.circular(
                                        100.r,
                                      ),
                                    ),
                                    child: Text(
                                      statusStr,
                                      style: AppTextStyles.titleSmall3(
                                        color: const Color(0xFF68776F),
                                      ),
                                    ),
                                  ),
                                ],
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
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: venue?.name ?? 'Chưa rõ sân',
                                            style:
                                                AppTextStyles.titleSmall3(
                                                  color: const Color(
                                                    0xFF14211A,
                                                  ),
                                                ).copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          if (venue?.address.isNotEmpty == true)
                                            TextSpan(
                                              text: ' • ${venue!.address}',
                                              style:
                                                  AppTextStyles.titleSmall3(
                                                    color: const Color(
                                                      0xFF14211A,
                                                    ),
                                                  ).copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          if (session
                                                  .courtNumbers
                                                  ?.isNotEmpty ==
                                              true)
                                            TextSpan(
                                              text:
                                                  ' • Sân số: ${session.courtNumbers}',
                                              style: AppTextStyles.titleSmall3(
                                                color: const Color(0xFF146C43),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
        ),
      ),
    );
  }
}

class _ProgressBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 50.h;
  @override
  double get maxExtent => 50.h;

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
              label = 'Số lượng $memberCount/$maxPlayers';
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
                  style: AppTextStyles.titleSmall3(
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
