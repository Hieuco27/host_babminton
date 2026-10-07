import 'package:get/get.dart';
import 'package:host_babminton/modules/ui/create_session/create_session_screen.dart';
import 'package:host_babminton/modules/ui/create_session/create_session_controller.dart';
import 'package:host_babminton/modules/ui/session_detail/session_detail_screen.dart';
import 'package:host_babminton/modules/ui/session_detail/session_detail_controller.dart';
import 'package:host_babminton/modules/ui/main_screen/main_screen.dart';
import 'package:host_babminton/modules/ui/main_screen/main_controller.dart';
import 'package:host_babminton/modules/ui/calendar/calendar_controller.dart';
import 'package:host_babminton/modules/ui/finance/finance_controller.dart';

class AppRoutes {
  AppRoutes._();
  static const mainRoute = '/main';

  static const String createSessionRoute = '/create-session';
  static const String sessionDetailRoute = '/session-detail';

  static List<GetPage> getPages() => [
    GetPage(
      name: mainRoute,
      page: () => const MainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MainController>(() => MainController(), fenix: true);
        Get.lazyPut<CalendarController>(
          () => CalendarController(),
          fenix: true,
        );
        Get.lazyPut<FinanceController>(() => FinanceController(), fenix: true);
      }),
    ),

    GetPage(
      name: createSessionRoute,
      page: () => const CreateSessionScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CreateSessionController>(() => CreateSessionController());
      }),
    ),
    GetPage(
      name: sessionDetailRoute,
      page: () => const SessionDetailScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SessionDetailController>(() => SessionDetailController());
      }),
    ),
  ];
}
