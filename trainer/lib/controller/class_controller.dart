import 'package:get/get.dart';
import 'package:trainer/model/class_info.dart';
import 'package:trainer/model/trainer_class.dart';
import 'package:trainer/service/backend/class_service.dart';
import 'package:trainer/service/firestore/class_service_mock.dart';

class ClassController extends GetxController {
  final ClassService classService;

  ClassController({required this.classService});

  final RxList<ClassInfo> listClassInfo = RxList<ClassInfo>();
  final RxBool _isLoadingTestGroup = RxBool(false);

  @override
  void onInit() {
    getClassList();
    super.onInit();
  }

  void getClassList() async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    classService.getClassList("6").then((value) {
      listClassInfo.value = value;
    });
  }

  ClassInfo? getClass(String classId) {
    for (var classInfo in listClassInfo.value) {
      if (classInfo.classId == classId) {
        return classInfo;
      }
    }

    return null;
  }
}