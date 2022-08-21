import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trainer/authentication_manager/auth_controller.dart';

class SplashScreenView extends StatelessWidget {
  static const routeName = '/splash';

  // final int milliseconds;

  SplashScreenView({
    Key? key,
  }) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   Future.delayed(
    //     Duration(seconds: milliseconds ~/ 1000),
    //         // () => Get.offNamed(LoginView.routeName),
    //   );
    // });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}