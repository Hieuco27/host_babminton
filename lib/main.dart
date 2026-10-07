import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:host_babminton/core/app_router.dart';
import 'package:host_babminton/core/app_theme.dart';

import 'package:host_babminton/core/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DatabaseService(), permanent: true);
  runApp(const MainApp(initialRoute: AppRoutes.mainRoute));
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          useInheritedMediaQuery: true,

          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,

          initialRoute: initialRoute,
          getPages: AppRoutes.getPages(),
        );
      },
    );
  }
}
