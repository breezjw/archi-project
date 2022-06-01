import 'package:get/get.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/class_controller.dart';
import 'package:trainer/controller/member_play_status_controller.dart';
import 'package:trainer/service/auth_service.dart';
import 'package:trainer/service/firestore/class_service.dart';
import 'package:trainer/service/firestore/member_play_status_service.dart';
import 'package:trainer/view/class_detail/class_detail_view.dart';
import 'package:trainer/view/class_play/class_play_view.dart';
import 'package:trainer/view/class_play/member_play_status_list_view.dart';
import 'package:trainer/view/login_view.dart';
import 'package:trainer/view/main_view.dart';
import 'package:trainer/view/memeber_play_status/member_play_status_view.dart';
import 'dependency_injector.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: MainView.routeName,
      page: () => const MainView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(ClassController(testGroupService: injector.get<ClassService>()));
      }),
    ),
    GetPage(
      name: ClassDetailView.routeName,
      page: () => const ClassDetailView(),
      binding: BindingsBuilder(() {
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        // Get.put(ClassController(testGroupService: injector.get<ClassService>()));
      }),
    ),
    GetPage(
      name: ClassPlayView.routeName,
      page: () => const ClassPlayView(),
      binding: BindingsBuilder(() {
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(MemberPlayStatusController(memberPlayStatusService: injector.get<MemberPlayStatusService>()));
      }),
    ),
    GetPage(
      name: MemberPlayStatusView.routeName,
      page: () => MemberPlayStatusView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(MemberPlayStatusController(memberPlayStatusService: injector.get<MemberPlayStatusService>()));
      }),
    ),
    GetPage(
      name: LoginView.routeName,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController(authService: injector.get<AuthService>()));
      })
    ),
  ];
}