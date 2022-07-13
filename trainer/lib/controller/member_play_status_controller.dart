import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_play_status.dart';
import 'package:trainer/service/firestore/member_play_status_service.dart';

class MemberPlayStatusController extends GetxController {
  final Logger _logger = Logger();

  final MemberPlayStatusService memberPlayStatusService;

  MemberPlayStatusController({required this.memberPlayStatusService});

  final RxList<Member> listMemberPlayStatus = RxList<Member>();
  final Rx<Member?> _memberPlayStatus = Rx<Member?>(null);
  // final RxBool _isLoadingTestGroup = RxBool(false);

  Member? get memberPlayStatus => _memberPlayStatus.value;

  @override
  void onInit() {
    // getMemberPlayStatus();
    loadListMemberPlayStatus();
    super.onInit();
  }

  Future<void> loadListMemberPlayStatus() async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    listMemberPlayStatus.bindStream(memberPlayStatusService.listMemberPlayStatusStream("class1"));
  }

  Future<void> getMemberPlayStatus(String docId) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
    _memberPlayStatus.bindStream(memberPlayStatusService.getMemberPlayStatusStream(docId));
  }

  // TrainerClass? getArticle(String id) {
  //   final testGroup = testGroups.firstWhereOrNull((element) =>
  //   element.docId == id,
  //   );
  //
  //   return testGroup;
  // }

  Future<void> updateMemberPlayStatus(Member memberPlayStatus) async {
    _logger.d("memberPlayStatus");
    memberPlayStatusService.updateMemberPlayStatus(memberPlayStatus);
  }
}