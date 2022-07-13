import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member.dart';

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
    _logger.d(member.docId);

    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
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