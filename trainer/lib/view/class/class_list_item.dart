import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/trainer_class.dart';
import 'package:trainer/view/class_detail/class_detail_view.dart';

class ClassListItem extends StatelessWidget {
  final TrainerClass trainerClass;

  const ClassListItem({
    Key? key,
    required this.trainerClass
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Logger _logger = Logger();

    _logger.d(trainerClass.name);

    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
          //TODO: Group Detail
          Get.toNamed(ClassDetailView.routeName, arguments: "test");
          // Get.to(() => NextPage(), arguments: value);
        },
        child: Container(
          decoration: BoxDecoration(
            //TODO: Group Status
            // color: done ? Colors.grey : Colors.green[100],
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Text(
                    "GROUP: ${trainerClass.name}",
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