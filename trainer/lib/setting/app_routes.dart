import 'package:get/get.dart';
import 'package:trainer/authentication_manager/auth_controller.dart';
import 'package:trainer/data_manager/class_data_manager.dart';
import 'package:trainer/data_manager/gems_data_manager.dart';
import 'package:trainer/data_manager/member_data_manager.dart';
import 'package:trainer/data_manager/repository/member_backend_repository.dart';
import 'package:trainer/exercise_controller/class_exercise_controller.dart';
import 'package:trainer/authentication_manager/auth_service.dart';
import 'package:trainer/exercise_controller/member_class_exercise_controller.dart';
import 'package:trainer/data_manager/repository/class_backend_repository.dart';
import 'package:trainer/data_manager/repository/gems_backend_repository.dart';
import 'package:trainer/realtime_data_agent/class_exercise_data_agent.dart';
import 'package:trainer/realtime_data_agent/member_class_exercise_data_agent.dart';
import 'package:trainer/ui/class_detail/class_detail_view.dart';
import 'package:trainer/ui/class_new/class_new_view.dart';
import 'package:trainer/ui/class_play/class_play_view.dart';
import 'package:trainer/ui/login_view.dart';
import 'package:trainer/ui/main_view.dart';
import 'package:trainer/ui/member_detail/member_detail_view.dart';
import 'package:trainer/ui/memeber_play_status/member_play_status_view.dart';
import 'package:trainer/ui/splash_view.dart';
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
        Get.put(ClassDataManager(classService: injector.get<ClassBackendRepository>()));
        Get.put(ClassExerciseController(
          classPlayStatusService: injector.get<ClassExerciseDataAgent>(),
          authService: injector.get<AuthService>()
        ));
        Get.put(MemberDataManager(memberBackendRepository: injector.get<MemberBackendRepository>()));
      }),
    ),
    GetPage(
      name: ClassNewView.routeName,
      page: () => const ClassNewView(),
      binding: BindingsBuilder(() {
        Get.put(ClassExerciseController(
            classPlayStatusService: injector.get<ClassExerciseDataAgent>(),
            authService: injector.get<AuthService>()
        ));
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(ClassDataManager(classService: injector.get<ClassBackendRepository>()));
        Get.put(MemberDataManager(memberBackendRepository: injector.get<MemberBackendRepository>()));
        Get.put(MemberClassExerciseController(memberPlayStatusService: injector.get<MemberClassExerciseDataAgent>()));
      }),
    ),
    GetPage(
      name: ClassDetailView.routeName,
      page: () => const ClassDetailView(),
      binding: BindingsBuilder(() {
        Get.put(ClassDataManager(classService: injector.get<ClassBackendRepository>()));
        Get.put(MemberClassExerciseController(memberPlayStatusService: injector.get<MemberClassExerciseDataAgent>()));
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        // Get.put(ClassController(testGroupService: injector.get<ClassService>()));
      }),
    ),
    GetPage(
      name: MemberDetailView.routeName,
      page: () => MemberDetailView(),
      binding: BindingsBuilder(() {
        Get.put(ClassExerciseController(
            classPlayStatusService: injector.get<ClassExerciseDataAgent>(),
            authService: injector.get<AuthService>()
        ));
        Get.put(GemsDataManager(gemsService: injector.get<GemsBackendRepository>()));
        Get.put(MemberClassExerciseController(memberPlayStatusService: injector.get<MemberClassExerciseDataAgent>()));
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        // Get.put(ClassController(testGroupService: injector.get<ClassService>()));
      }),
    ),
    GetPage(
      name: ClassPlayView.routeName,
      page: () => const ClassPlayView(),
      binding: BindingsBuilder(() {
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(ClassExerciseController(
            classPlayStatusService: injector.get<ClassExerciseDataAgent>(),
            authService: injector.get<AuthService>()
        ));
        Get.put(MemberClassExerciseController(memberPlayStatusService: injector.get<MemberClassExerciseDataAgent>()));
      }),
    ),
    GetPage(
      name: MemberPlayStatusView.routeName,
      page: () => MemberPlayStatusView(),
      binding: BindingsBuilder(() {
        // Get.put(AuthController(authService: injector.get<AuthService>()));
        Get.put(MemberClassExerciseController(memberPlayStatusService: injector.get<MemberClassExerciseDataAgent>()));
      }),
    ),
  ];
}