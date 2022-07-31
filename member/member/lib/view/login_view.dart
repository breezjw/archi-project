
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'main_view.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';

  LoginView({Key? key}) : super(key: key);

  final AuthController _authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              // controller: _loginController.emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            TextField(
              // controller: _loginController.passwordController,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    ///padding: const EdgeInsets.all(8),
                    //color: Colors.blue,
                    onPressed: () async {
                      // bool result = await _loginController
                      //     .handleSignIn(SignInType.EMAIL_PASSWORD);
                      // if (result) Get.offNamed(MainView.routeName);
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    //padding: const EdgeInsets.all(8),
                    //color: Colors.primaries[0],
                    onPressed: () async {
                      bool result = await _authController
                          .handleSignIn(SignInType.GOOGLE);
                      if (result) Get.offNamed(MainView.routeName);
                    },
                    child: const Text(
                      "SignIn with Google",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Get.toNamed("/register");
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text("No account ? Register Here!"),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}