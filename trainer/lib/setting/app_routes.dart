import 'package:get/get.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/class_controller.dart';
import 'package:trainer/controller/class_play_status_controller.dart';
import 'package:trainer/controller/member_controller.dart';
import 'package:trainer/controller/member_play_status_controller.dart';
import 'package:trainer/model/class_play_status.dart';
import 'package:trainer/service/auth_service.dart';
import 'package:trainer/service/backend/member_service.dart';
import 'package:trainer/service/firestore/class_play_status_service.dart';
import 'package:trainer/service/firestore/class_service.dart';
import 'package:trainer/service/firestore/member_play_status_service.dart';
import 'package:trainer/view/class_detail/class_detail_view.dart';
import 'package:trainer/view/class_new/class_new_view.dart';
import 'package:trainer/view/class_play/class_play_view.dart';
import 'package:trainer/view/class_play/member_play_status_list_view.dart';
import 'package:trainer/view/login_view.dart';
import 'package:trainer/view/main_view.dart';
import 'package:trainer/view/memeber_play_status/member_play_status_view.dart';
import 'package:trainer/view/splash_view.dart';
import 'dependency_injector.dart';

class AppRoutes {
  static final routes = [
    GetPage(
        name: SplashScreenView.routeName,
        page: () => SplashScreenView(),
        binding: BindingsBuilder(() {
          Get.put(AuthController(authService: injector.get<AuthService>()));
        })
    ),
    GetPage(
        name: LoginView.routeName,
        page: () => LoginView(),
        binding: BindingsBuilder(() {
          // Get.put(AuthController(authService: injector.get<AuthService>()));
          Get.lazyPut(() => AuthController(
            authService: injector.get<AuthService>(),
          ), fenix: false);
        })
    ),
    GetPage(
      name: MainView.routeName,
      page: () => const MainView(),
      binding: BindingsBuilder(() {
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(ClassController(testGroupService: injector.get<ClassService>()));
        Get.put(ClassPlayStatusController(
          classPlayStatusService: injector.get<ClassPlayStatusService>(),
          authService: injector.get<AuthService>()
        ));
        Get.put(MemberController(memberService: injector.get<MemberService>()));
      }),
    ),
    GetPage(
      name: ClassNewView.routeName,
      page: () => const ClassNewView(),
      binding: BindingsBuilder(() {
        Get.put(ClassPlayStatusController(
            classPlayStatusService: injector.get<ClassPlayStatusService>(),
            authService: injector.get<AuthService>()
        ));
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(ClassController(testGroupService: injector.get<ClassService>()));
        Get.put(MemberController(memberService: injector.get<MemberService>()));
      }),
    ),
    GetPage(
      name: ClassDetailView.routeName,
      page: () => const ClassDetailView(),
      binding: BindingsBuilder(() {
        Get.put(ClassPlayStatusController(
            classPlayStatusService: injector.get<ClassPlayStatusService>(),
            authService: injector.get<AuthService>()
        ));
       Get.put(MemberPlayStatusController(memberPlayStatusService: injector.get<MemberPlayStatusService>()));
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        // Get.put(ClassController(testGroupService: injector.get<ClassService>()));
      }),
    ),
    GetPage(
      name: ClassPlayView.routeName,
      page: () => const ClassPlayView(),
      binding: BindingsBuilder(() {
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(ClassPlayStatusController(
            classPlayStatusService: injector.get<ClassPlayStatusService>(),
            authService: injector.get<AuthService>()
        ));
        Get.put(MemberPlayStatusController(memberPlayStatusService: injector.get<MemberPlayStatusService>()));
      }),
    ),
    GetPage(
      name: MemberPlayStatusView.routeName,
      page: () => MemberPlayStatusView(),
      binding: BindingsBuilder(() {
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(MemberPlayStatusController(memberPlayStatusService: injector.get<MemberPlayStatusService>()));
      }),
    ),
  ];
}