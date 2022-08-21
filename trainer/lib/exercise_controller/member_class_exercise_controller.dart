import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_exercise.dart';
import 'package:trainer/realtime_data_agent/member_class_exercise_data_agent.dart';

class MemberClassExerciseController extends GetxController {
  final Logger _logger = Logger();

  final MemberClassExerciseDataAgent memberPlayStatusService;

  MemberClassExerciseController({required this.memberPlayStatusService});

  final RxList<MemberClassExercise> listMemberPlayStatus = RxList<MemberClassExercise>();
  final Rx<MemberClassExercise?> _memberPlayStatus = Rx<MemberClassExercise?>(null);
  // final RxBool _isLoadingTestGroup = RxBool(false);

  MemberClassExercise? get memberPlayStatus => _memberPlayStatus.value;

  @override
  void onInit() {
    // getMemberPlayStatus();
    // loadListMemberPlayStatus();
    super.onInit();
  }

  Future<void> getListMemberClassExercise(String classId, int exerciseCount) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    listMemberPlayStatus.bindStream(memberPlayStatusService.listMemberClassExerciseStream(classId, exerciseCount));
  }

  Future<void> getMemberClassExercise(String docId) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
    _memberPlayStatus.bindStream(memberPlayStatusService.getMemberClassExerciseStream(docId));
  }

  Future<void> addMemberClassExercise(String classId, String memberId, String memberName) async {
    _logger.d("memberPlayStatus");
    memberPlayStatusService.addMemberClassExercise(classId, memberId, memberName);
  }

  Future<void> updateMemberClassExercise(MemberClassExercise memberClassExercise) async {
    _logger.d("memberPlayStatus");
    memberPlayStatusService.updateMembeClassrExercise(memberClassExercise);
  }
}