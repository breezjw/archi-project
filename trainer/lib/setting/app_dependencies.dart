import 'package:trainer/authentication_manager/auth_service.dart';
import 'package:trainer/data_manager/repository/class_backend_repository.dart';
import 'package:trainer/data_manager/repository/gems_backend_repository.dart';
import 'package:trainer/data_manager/repository/member_backend_repository.dart';
import 'package:trainer/realtime_data_agent/class_exercise_data_agent.dart';
import 'package:trainer/realtime_data_agent/member_class_exercise_data_agent.dart';
import 'dependency_injector.dart';

Future<void> setupDependencies() async {
  injector.registerSingleton<AuthService>(AuthService());
  injector.registerSingleton<ClassBackendRepository>(ClassBackendRepository());
  injector.registerSingleton<MemberBackendRepository>(MemberBackendRepository());
  injector.registerSingleton<GemsBackendRepository>(GemsBackendRepository());
  injector.registerSingleton<ClassExerciseDataAgent>(ClassExerciseDataAgent());
  injector.registerSingleton<MemberClassExerciseDataAgent>(MemberClassExerciseDataAgent());
}