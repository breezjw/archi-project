import 'package:get/get.dart';
import 'package:trainer/model/trainer_class.dart';
import 'package:trainer/service/firestore/class_service.dart';

class ClassController extends GetxController {
  final ClassService testGroupService;

  ClassController({required this.testGroupService});

  final RxList<TrainerClass> listTrainerClass = RxList<TrainerClass>();
  final RxBool _isLoadingTestGroup = RxBool(false);

  @override
  void onInit() {
    loadClass();
    super.onInit();
  }

  Future<void> loadClass() async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    listTrainerClass.bindStream(testGroupService.listClassSnapshot("aaa"));
  }

  TrainerClass? getArticle(String id) {
    final testGroup = listTrainerClass.firstWhereOrNull((element) =>
    element.docId == id,
    );

    return testGroup;
  }
}