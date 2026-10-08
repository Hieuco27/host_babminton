import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:host_babminton/core/text_styles.dart';
import 'finance_controller.dart';

class FinanceScreen extends GetView<FinanceController> {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOverviewCards(),
                            SizedBox(height: 16.h),
                            _buildSearchField(),
                            SizedBox(height: 16.h),
                            _buildHistorySectionHeader(),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.sessionItems.isEmpty &&
                          controller.searchQuery.value.isEmpty) {
                        return SliverToBoxAdapter(child: _buildEmptyState());
                      } else if (controller.sessionItems.isEmpty &&
                          controller.searchQuery.value.isNotEmpty) {
                        return SliverToBoxAdapter(child: _buildNoMatchState());
                      }
                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ).copyWith(bottom: 24.h),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = controller.sessionItems[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildSessionCard(item),
                            );
                          }, childCount: controller.sessionItems.length),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F8),
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 16.h, bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quản lý Tài chính',
            style: AppTextStyles.titleLarge().copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14211A),
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () => _showMonthPicker(context),
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE1E6E3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      'Tháng ${controller.selectedMonth.value.month}, ${controller.selectedMonth.value.year}',
                      style: AppTextStyles.bodyMedium(),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xFF68776F),
                    size: 24.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return Obx(() {
      int totalCost = controller.totalCost.value;
      int totalCollected = controller.totalCollected.value;
      int debt = totalCost - totalCollected;

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE1E6E3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/finance/archive.svg',
                      width: 18.w,
                      height: 18.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Tổng chi phí sân & cầu',
                      style: AppTextStyles.titleSmall3(
                        color: const Color(0xFF68776F),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '${formatter.format(totalCost)}đ',
                  style: AppTextStyles.titleMediumIcon().copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14211A),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFE1E6E3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/finance/money.svg',
                            width: 15.w,
                            height: 15.h,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Tổng tiền đã thu',
                            style: AppTextStyles.titleSmall3(
                              color: const Color(0xFF68776F),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${formatter.format(totalCollected)}đ',
                        style: AppTextStyles.titleMediumIcon().copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF146C43),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: debt > 0
                        ? const Color(0xFFFFE8DF)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: debt > 0
                          ? const Color(0xFFFCD6DC)
                          : const Color(0xFFC8E6C9),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt > 0 ? 'Còn thiếu / Nợ' : 'Đã thu đủ',
                        style: AppTextStyles.titleSmall3(
                          color: debt > 0
                              ? const Color(0xFFC8431B)
                              : const Color(0xFF146C43),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        debt > 0 ? '${formatter.format(debt)}đ' : '0đ',
                        style: AppTextStyles.titleMediumIcon().copyWith(
                          fontWeight: FontWeight.bold,
                          color: debt > 0
                              ? const Color(0xFFC8431B)
                              : const Color(0xFF146C43),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildSearchField() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE1E6E3)),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Icon(
              Icons.search,
              color: const Color(0xFF68776F),
              size: 24.w,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.updateSearchQuery,
              style: AppTextStyles.bodyLargeEmphasized(),
              decoration: InputDecoration(
                hintText: 'Tìm theo tên sân',
                hintStyle: AppTextStyles.bodyLarge(
                  color: const Color(0xFF68776F),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: Icon(
                  Icons.close,
                  color: const Color(0xFF68776F),
                  size: 20.w,
                ),
                onPressed: controller.clearSearch,
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildHistorySectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lịch sử các buổi chơi',
          style: AppTextStyles.titleMediumBlack().copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(
          () => Text(
            '${controller.sessionItems.length} buổi',
            style: AppTextStyles.bodyMedium().copyWith(
              color: const Color(0xFF68776F),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(FinanceSessionItem item) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    final dateStr = DateFormat('dd/MM/yyyy').format(item.session.date);
    final venueName = item.session.venue.value?.name ?? 'Chưa xác định';

    int sTotal = item.invoice.shuttlecockPrice * item.invoice.shuttlecockCount;
    String breakdown =
        'Sân ${formatter.format(item.invoice.courtFee)}đ + Cầu ${formatter.format(sTotal)}đ';
    if (item.totalExtras > 0) {
      breakdown += ' + Khác ${formatter.format(item.totalExtras)}đ';
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE1E6E3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/calendar/time.svg',
                      width: 14.w,
                      height: 14.h,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      dateStr,
                      style: AppTextStyles.bodyMedium().copyWith(
                        color: const Color(0xFF68776F),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFF68776F),
                  size: 16.w,
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: SvgPicture.asset(
                    'assets/images/calendar/location.svg',
                    width: 14.w,
                    height: 14.h,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    venueName,
                    style: AppTextStyles.titleMediumBlack().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/finance/archive.svg',
                  width: 15.w,
                  height: 15.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  '${formatter.format(item.totalCost)}đ',
                  style: AppTextStyles.titleMediumIcon().copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14211A),
                  ),
                ),
              ],
            ),
            Text(
              breakdown,
              style: AppTextStyles.labelLarge2().copyWith(
                color: const Color(0xFF68776F),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 16.w,
                  color: const Color(0xFF68776F),
                ),
                SizedBox(width: 6.w),
                Text(
                  '${item.totalPresent} người (${item.presentMales} Nam – ${item.presentFemales} Nữ)',
                  style: AppTextStyles.labelLarge2().copyWith(
                    color: const Color(0xFF68776F),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF005A9E),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Nam ${formatter.format(item.invoice.maleFee)}đ',
                  style: AppTextStyles.labelLarge2().copyWith(
                    color: const Color(0xFF68776F),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9E003D),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Nữ ${formatter.format(item.invoice.femaleFee)}đ',
                  style: AppTextStyles.labelLarge2().copyWith(
                    color: const Color(0xFF68776F),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (item.debtCount > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A3D),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 14.w,
                      color: const Color(0xFF14211A),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Còn thiếu ${formatter.format(item.totalCost - item.totalCollected)}đ (${item.debtCount} người)',
                      style: AppTextStyles.titleSmall3(
                        color: const Color(0xFF14211A),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF146C43),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 14.w, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      'Đã thu đủ',
                      style: AppTextStyles.titleSmall3(color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64.w,
              color: const Color(0xFFD5DBD8),
            ),
            SizedBox(height: 16.h),
            Text(
              'Chưa có buổi nào trong tháng này',
              style: AppTextStyles.titleMediumBlack(),
            ),
            SizedBox(height: 8.h),
            Text(
              'Chốt hóa đơn một buổi để xem thống kê ở đây',
              style: AppTextStyles.bodyMedium().copyWith(
                color: const Color(0xFF68776F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMatchState() {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Center(
        child: Text(
          'Không tìm thấy sân nào khớp với "${controller.searchQuery.value}"',
          style: AppTextStyles.bodyMedium().copyWith(
            color: const Color(0xFF68776F),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
    int currentYear = controller.selectedMonth.value.year;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            size: 28.w,
                            color: const Color(0xFF14211A),
                          ),
                          onPressed: () => setState(() => currentYear--),
                        ),
                        Text(
                          '$currentYear',
                          style: AppTextStyles.titleMediumBlack().copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            size: 28.w,
                            color: const Color(0xFF14211A),
                          ),
                          onPressed: () => setState(() => currentYear++),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        int month = index + 1;
                        bool isSelected =
                            currentYear ==
                                controller.selectedMonth.value.year &&
                            month == controller.selectedMonth.value.month;
                        return GestureDetector(
                          onTap: () {
                            controller.changeMonth(
                              DateTime(currentYear, month),
                            );
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF146C43)
                                  : const Color(0xFFF4F6F8),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'Tháng $month',
                              style: AppTextStyles.bodyLarge().copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF14211A),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
