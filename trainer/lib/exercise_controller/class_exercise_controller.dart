
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/class_exercise.dart';
import 'package:trainer/authentication_manager/auth_service.dart';
import 'package:trainer/realtime_data_agent/class_exercise_data_agent.dart';


class ClassExerciseController extends GetxController {
  final Logger logger = Logger();

  final ClassExerciseDataAgent classPlayStatusService;
  final AuthService authService;

  ClassExerciseController({
    required this.classPlayStatusService,
    required this.authService
  });

  // final RxList<ClassPlayStatus> listClassPlayStatus = RxList<ClassPlayStatus>();
  final Rx<ClassExercise?> _classPlayStatus = Rx<ClassExercise?>(null);
  final RxBool _isLoading = RxBool(false);

  ClassExercise? get classPlayStatus => _classPlayStatus.value;

  @override
  void onInit() {
    logger.d(authService.user);
    super.onInit();
  }

  Future<ClassExercise> getClassExerciseByClassId(String classId) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
    return classPlayStatusService.getClassExerciseByClassId(classId);
  }

  Future<void> bindClassExercise(String docId) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
    _classPlayStatus.bindStream(classPlayStatusService.getClassExerciseStreamByClassId(docId));
  }

  Future<String?> addClassExercise(String classId) async {
    return classPlayStatusService.addClassExercise(classId);
  }

  Future<void> startClassExercise(String classId) async {
    classPlayStatusService.getClassExerciseByClassId(classId)
    .then((doc) {

      logger.d(doc.classExerciseId);

      return classPlayStatusService.updateClassExercise(
        doc.classExerciseId,
        status: "play",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        playCount: doc.exerciseCount + 1
      );
    });
  }

  Future<void> stopClassExercise(String classId) async {

    classPlayStatusService.getClassExerciseByClassId(classId)
    .then((doc) {
      return classPlayStatusService.updateClassExercise(
          doc.classExerciseId,
          status: "stop",
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          playCount: doc.exerciseCount
      );
    });

    // return classPlayStatusService.updateClassPlayStatus(
    //   docId,
    //   status: "stop",
    //   endDate: DateTime.now()
    // );
  }
}