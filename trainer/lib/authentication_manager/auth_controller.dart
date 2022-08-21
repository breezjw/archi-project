import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trainer/ui/main_view.dart';
import 'package:logger/logger.dart';
import 'package:trainer/authentication_manager/auth_service.dart';

enum SignInType { EMAIL_PASSWORD, GOOGLE }

class AuthController extends GetxController {
  final AuthService authService;

  AuthController({required this.authService});
  static AuthController to = Get.find();

  Logger logger = Logger();

  //static AuthController instance = Get.find();
  //RxBool isLogged = false.obs;
  Rxn<User> user = Rxn<User>();

  // late AuthService _authService;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    // _authService = AuthService();

    // user.value = authService.getCurrentUser();
    logger.d("$user");

    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.onInit();
  }

  @override
  void onReady() async {
    ever(user, handleAuthChanged);
    user.bindStream(authService.onAuthChanged());

    // await handleAuthChanged(user);

    super.onReady();
  }

  handleAuthChanged(user) {
    logger.d("handleAuthChanged");
    logger.d(user);
    if (user == null) {
      logger.d("Go /login");
      Get.offAllNamed("/login");
    } else {
      logger.d("Go /");
      Get.offAllNamed(MainView.routeName);
    }
  }

  Future<bool> handleSignIn(SignInType type) async {
    // return true;

    if (type == SignInType.EMAIL_PASSWORD) {
      if (emailController.text == "" || passwordController.text == "") {
        Get.snackbar(
          "Error",
          "Empty email or password",
        );
        return false;
      }
    }

    // Get.snackbar("Signing In", "Loading",
    //     showProgressIndicator: true,
    //     snackPosition: SnackPosition.BOTTOM,
    //     duration: Duration(minutes: 2));

    try {
      if (type == SignInType.GOOGLE) {
        await authService.signInWithGoogle();
        Get.offAllNamed("/");
      }
    } on Exception catch (_, e) {
      // Get.back();
      Get.defaultDialog(title: "Error", middleText: e.toString(), actions: [
        FlatButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Close"),
        ),
      ]);
      logger.e(e);
    }

    return true;
  }

  handleSignOut() async{
    logger.d("SIGN OUT");
    await authService.signOut();
  }
}