
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/service/backend/member_service.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class MemberController extends GetxController {
  final Logger logger = Logger();

  final MemberService memberService;
  MemberController({required this.memberService});

  final RxList<Member> listMember = RxList<Member>();

  @override
  void onInit() {
    getMemberList();
    super.onInit();
  }

   void getMemberList() async {
    memberService.getMemberList().then((value) {
      listMember.value = value;
    });
  }
}