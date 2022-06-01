import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/class_controller.dart';
import 'package:trainer/view/class/class_list_item.dart';

class ClassListView extends StatelessWidget {
  ClassListView({Key? key}) : super(key: key);

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    ClassController classController = Get.find<ClassController>();

    return Obx(() => Column(children: [
        Expanded(
          child: classController.listTrainerClass.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
              itemCount: classController.listTrainerClass.length,
              itemBuilder: (context, index) {
                return ClassListItem(
                  trainerClass: classController.listTrainerClass[index]
                );
              }
          )
        )
      ])
    );
  }
}