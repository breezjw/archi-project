import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/class_controller.dart';
import 'package:trainer/controller/member_controller.dart';
import 'package:trainer/controller/member_play_status_controller.dart';
import 'package:trainer/service/firestore/member_play_status_service.dart';
import 'package:trainer/view/class_detail/member_list_item.dart';
import 'package:trainer/view/class_list/class_list_item.dart';
import 'package:trainer/view/class_play/member_paly_status_list_item.dart';

class MemberListView extends StatelessWidget {
  MemberListView({Key? key}) : super(key: key);

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    // MemberPlayStatusController memberPlayStatusController = Get.find<MemberPlayStatusController>();
    MemberController memberController = Get.find<MemberController>();

    return Obx(() => memberController.listMember.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: memberController.listMember.length,
        itemBuilder: (context, index) {
          return MemberListItem(
            member: memberController.listMember[index]
          );
        }
    )
    );
  }
}