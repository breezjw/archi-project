import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/ui/member_detail/member_detail_view.dart';

class MemberListItem extends StatelessWidget {
  final Member member;

  const MemberListItem({
    Key? key,
    required this.member
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Logger _logger = Logger();

    _logger.d(member.name);
    _logger.d(member.memberId);

    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
          //TODO: Group Detail
          // _logger.d("HERE");
          Get.toNamed(MemberDetailView.routeName, arguments: member.memberId);
        },
        child: Container(
          decoration: BoxDecoration(
            //TODO: Group Status
            // color: done ? Colors.grey : Colors.green[100],
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Text(
                    "Name: ${member.name}",
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