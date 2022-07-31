import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trainer/setting/app_dependencies.dart';
import 'package:trainer/setting/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await setupDependencies();
  //Get.testMode = true;

  runApp(
    Container(
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppRoutes.routes,
      //initialRoute: '/splash',
      // initialRoute: '/login',
      initialRoute: '/member_main',
      //initialRoute: '/member_play_status',
      navigatorKey: Get.key,
    );
  }
}