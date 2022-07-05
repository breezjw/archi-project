import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/class_controller.dart';
import 'package:trainer/controller/member_controller.dart';
import 'package:trainer/view/class/class_list_item.dart';
import 'package:trainer/view/common/common_widgets.dart';

class ClassListView extends StatelessWidget {
  ClassListView({Key? key}) : super(key: key);

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    ClassController classController = Get.find<ClassController>();
    MemberController memberController = Get.find<MemberController>();

    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: [
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
              ),

          ),
          buildButton(
            buttonText: "ADD NEW CLASS",
            onPressed: () {}
          )
        ]),
    )
    );
  }
}