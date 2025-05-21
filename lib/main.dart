import 'package:flutter/material.dart';
import 'package:flutter_noti/screens/onboarding_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_noti/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notiService = NotiService();
  await notiService.initNotification();
  Get.put<NotiService>(notiService);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: OnboardingScreen(),
      ),
    );
  }
}
