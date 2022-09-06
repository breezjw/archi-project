
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member.dart';

import 'repository/member_backend_repository.dart';

class MemberDataManager extends GetxController {
  final Logger logger = Logger();

  final MemberBackendRepository memberBackendRepository;
  MemberDataManager({required this.memberBackendRepository});

  final RxList<Member> listMember = RxList<Member>();

  @override
  void onInit() {
    getMemberList();
    super.onInit();
  }

  Future<void> getMemberList() async {
    return memberBackendRepository.getMemberList().then((value) {
      listMember.value = value;
    });
  }

  Member? getMember(String id) {
    for (var member in listMember.value) {
      if (member.memberId == id) {
        return member;
      }
    }

    return null;
  }
}