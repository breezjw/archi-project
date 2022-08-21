import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/exercise_controller/member_class_exercise_controller.dart';
import 'package:trainer/ui/class_play/member_paly_status_list_item.dart';

class MemberPlayStatusListView extends StatelessWidget {
  MemberPlayStatusListView({Key? key}) : super(key: key);

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    logger.d("HERE");
    MemberClassExerciseController memberPlayStatusController = Get.find<MemberClassExerciseController>();

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