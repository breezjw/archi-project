import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/class_controller.dart';
import 'package:trainer/controller/member_play_status_controller.dart';
import 'package:trainer/service/firestore/member_play_status_service.dart';
import 'package:trainer/view/class_list/class_list_item.dart';
import 'package:trainer/view/class_play/member_paly_status_list_item.dart';

class MemberPlayStatusListView extends StatelessWidget {
  MemberPlayStatusListView({Key? key}) : super(key: key);

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    logger.d("HERE");
    MemberPlayStatusController memberPlayStatusController = Get.find<MemberPlayStatusController>();

    return Obx(() => memberPlayStatusController.listMemberPlayStatus.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: memberPlayStatusController.listMemberPlayStatus.length,
        itemBuilder: (context, index) {
          return MemberPlayStatusListItem(
            memberPlayStatus: memberPlayStatusController.listMemberPlayStatus[index]
          );
        }
    )
    );
  }
}