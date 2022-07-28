import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_play_status.dart';
import 'package:trainer/model/trainer_class.dart';
import 'package:trainer/view/class_detail/class_detail_view.dart';
import 'package:trainer/view/memeber_play_status/member_play_status_view.dart';

class MemberListItem extends StatelessWidget {
  final Member memberPlayStatus;

  const MemberListItem({
    Key? key,
    required this.memberPlayStatus
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Logger _logger = Logger();

    _logger.d(memberPlayStatus.name);
    _logger.d(memberPlayStatus.docId);

    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
          //TODO: Group Detail
          // _logger.d("HERE");
          // Get.toNamed(MemberPlayStatusView.routeName, arguments: memberPlayStatus.docId);
        },
        child: Container(
          decoration: BoxDecoration(
            //TODO: Group Status
            // color: done ? Colors.grey : Colors.green[100],
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Text(
                    "Name: ${memberPlayStatus.name}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}