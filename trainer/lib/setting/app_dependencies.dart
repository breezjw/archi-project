import 'package:trainer/service/auth_service.dart';
import 'package:trainer/service/firestore/class_play_status_service.dart';
import 'package:trainer/service/firestore/class_service.dart';
import 'package:trainer/service/firestore/member_play_status_service.dart';
import 'dependency_injector.dart';

Future<void> setupDependencies() async {
  injector.registerSingleton<AuthService>(AuthService());
  injector.registerSingleton<ClassService>(ClassService());
  injector.registerSingleton<ClassPlayStatusService>(ClassPlayStatusService());
  injector.registerSingleton<MemberPlayStatusService>(MemberPlayStatusService());
}