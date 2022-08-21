import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/data_manager/class_data_manager.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/ui/class_detail/member_list_item.dart';

class MemberListView extends StatelessWidget {
  final String classId;

  MemberListView({
    Key? key,
    required this.classId
  }) : super(key: key);

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    // MemberPlayStatusController memberPlayStatusController = Get.find<MemberPlayStatusController>();
    // MemberController memberController = Get.find<MemberController>();
    ClassDataManager classController = Get.find<ClassDataManager>();

    return FutureBuilder(
        future: classController.getClassMemberList(classId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return const Text(
              "Failed to load members",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            );
          }
          else {
            final List<Member> members = snapshot.data;
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                return MemberListItem(
                    member: members[index]
                );
              }
            );
          }
        }
    );

    // return Obx(() => memberController.listMember.isEmpty
    //   ? const Center(child: CircularProgressIndicator())
    //   : ListView.builder(
    //     itemCount: memberController.listMember.length,
    //     itemBuilder: (context, index) {
    //       return MemberListItem(
    //         member: memberController.listMember[index]
    //       );
    //     }
    // )
    // );
  }
}