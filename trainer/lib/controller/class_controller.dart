import 'package:get/get.dart';
import 'package:trainer/model/class_info.dart';
import 'package:trainer/model/member.dart';
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

  Future<void> getClassList() async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    return classService.getClassList("6").then((value) {
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

  Future<void> addClass(String name, String trainerId) async {
    return classService.addClass(name: name, trainerId: trainerId);
  }

  Future<List<Member>> getClassMemberList(String classId) async {
    return classService.getClassMemberList("6", classId);
  }

  Future<void> addClassMember(String trainerId, String classId, List<int> memberIds) async {
    return classService.addClassMember(trainerId: trainerId, classId: classId, memberIds: memberIds);
  }
}