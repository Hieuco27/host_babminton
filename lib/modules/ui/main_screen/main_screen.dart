import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:host_babminton/core/app_colors.dart';
import 'package:host_babminton/core/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:host_babminton/modules/ui/main_screen/main_controller.dart';
import 'package:host_babminton/modules/ui/calendar/calendar_screen.dart';
import 'package:host_babminton/modules/ui/finance/finance_screen.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // extendBody: false,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [CalendarScreen(), FinanceScreen()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent, // tắt ripple khi tap
            highlightColor: Colors.transparent, // tắt màu xám giữ ngón tay
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFEEEEEE), width: 0.8),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.gradientStart,
              unselectedItemColor: AppColors.textSecondary,
              selectedLabelStyle: AppTextStyles.titleSmall3(),
              unselectedLabelStyle: AppTextStyles.titleSmall3(),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/calendar/calendar.svg',
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/images/calendar/calendar.svg',
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      AppColors.gradientStart,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Lịch',
                ),

                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/finance/card.svg',
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/images/finance/card.svg',
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      AppColors.gradientStart,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Tài chính',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
