
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/class_play_status.dart';
import 'package:trainer/service/auth_service.dart';
import 'package:trainer/service/firestore/class_play_status_service.dart';

class ClassPlayStatusController extends GetxController {
  final Logger logger = Logger();

  final ClassPlayStatusService classPlayStatusService;
  final AuthService authService;

  ClassPlayStatusController({
    required this.classPlayStatusService,
    required this.authService
  });

  // final RxList<ClassPlayStatus> listClassPlayStatus = RxList<ClassPlayStatus>();
  final Rx<ClassPlayStatus?> _classPlayStatus = Rx<ClassPlayStatus?>(null);
  final RxBool _isLoading = RxBool(false);

  ClassPlayStatus? get classPlayStatus => _classPlayStatus.value;

  @override
  void onInit() {
    logger.d(authService.user);
    super.onInit();
  }

  Future<ClassPlayStatus> getClassPlayStatusByClassId(String classId) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
    return classPlayStatusService.getClassPlayStatusByClassId(classId);
  }

  Future<void> bindClassPlayStatus(String docId) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
    _classPlayStatus.bindStream(classPlayStatusService.getClassPlayStatusStreamByClassId(docId));
  }

  Future<String?> addClassPlayStatus(String classId) async {
    return classPlayStatusService.addClassPlayStatus(classId);
  }

  Future<void> startClassPlayStatus(String classId) async {
    classPlayStatusService.getClassPlayStatusByClassId(classId)
    .then((doc) {

      logger.d(doc.docId);

      return classPlayStatusService.updateClassPlayStatus(
        doc.docId,
        status: "play",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        playCount: doc.playCount + 1
      );
    });
  }

  Future<void> stopClassPlayStatus(String classId) async {

    classPlayStatusService.getClassPlayStatusByClassId(classId)
    .then((doc) {
      return classPlayStatusService.updateClassPlayStatus(
          doc.docId,
          status: "stop",
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          playCount: doc.playCount + 1
      );
    });

    // return classPlayStatusService.updateClassPlayStatus(
    //   docId,
    //   status: "stop",
    //   endDate: DateTime.now()
    // );
  }
}