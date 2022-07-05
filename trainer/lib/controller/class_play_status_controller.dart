
import 'package:get/get.dart';
import 'package:trainer/model/class_play_status.dart';
import 'package:trainer/service/firestore/class_play_status_service.dart';

class ClassPlayStatusController extends GetxController {
  final ClassPlayStatusService classPlayStatusService;

  ClassPlayStatusController({required this.classPlayStatusService});

  // final RxList<ClassPlayStatus> listClassPlayStatus = RxList<ClassPlayStatus>();
  final Rx<ClassPlayStatus?> _classPlayStatus = Rx<ClassPlayStatus?>(null);
  final RxBool _isLoading = RxBool(false);

  ClassPlayStatus? get classPlayStatus => _classPlayStatus.value;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getClassPlayStatus(String docId) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
    _classPlayStatus.bindStream(classPlayStatusService.getClassPlayStatusStream(docId));
  }

  Future<String?> addClassPlayStatus(String classId) async {
    return classPlayStatusService.addClassPlayStatus(classId);
  }

  Future<void> stopClassPlayStatus(String docId) async {
    return classPlayStatusService.updateClassPlayStatus(
      docId,
      status: "finish",
      endDate: DateTime.now()
    );
  }
}