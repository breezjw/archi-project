import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/authentication_manager/auth_controller.dart';
import 'package:trainer/data_manager/class_data_manager.dart';
import 'package:trainer/data_manager/member_data_manager.dart';
import 'package:trainer/exercise_controller/class_exercise_controller.dart';
import 'package:trainer/exercise_controller/member_class_exercise_controller.dart';
import 'package:trainer/ui/common/common_widgets.dart';

import '../class_play/class_play_view.dart';

class ClassNewView extends StatefulWidget {
  static const routeName = '/class_new';

  const ClassNewView({Key? key}) : super(key: key);

  @override
  _ClassNewViewState createState() => _ClassNewViewState();
}

class _ClassNewViewState extends State<ClassNewView>
    with SingleTickerProviderStateMixin{

  final Logger logger = Logger();

  final AuthController _authController = AuthController.to;
  ClassDataManager classController = Get.find<ClassDataManager>();
  MemberDataManager memberController = Get.find<MemberDataManager>();
  ClassExerciseController classPlayStatusController = Get.find<ClassExerciseController>();
  MemberClassExerciseController memberPlayStatusController = Get.find<MemberClassExerciseController>();

  late List<bool> _isChecked;
  TextEditingController classNameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(memberController.listMember.length, false);
  }

  @override
  Widget build(BuildContext context) {

    memberController.getMemberList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("GEMS Trainer"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () {
                _authController.handleSignOut();
              },
            )
          ],
        ),
      ),
      body: Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: memberController.listMember.length == 0
            ? const Center(child: CircularProgressIndicator())
            :Column(
              children: [
                buildTitleText(text:"Class Info"),
                buildTextField(label: "Class Name", controller: classNameTextController),
                buildTextField(label: "Exercise Type"),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Class Member"),
                Expanded(
                  child: ListView.builder(
                    itemCount: memberController.listMember.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(memberController.listMember[index].name),
                        value: _isChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            logger.d("$index: ${value}");
                            _isChecked[index] = value!;
                          });
                        },
                      );
                    },
                  )
                ),
                buildButton(
                    buttonText: "ADD CLASS",
                    onPressed: () async {
                      await classController.addClass(classNameTextController.text, "6");
                      await classController.getClassList();

                      var classInfo = classController.listClassInfo
                        .reduce((pre, cur) => int.parse(pre.classId) > int.parse(cur.classId) ? pre : cur);

                      List<int> checkedIndex = [];

                      _isChecked.asMap().forEach((index, value) async {
                         if (value) {
                           checkedIndex.add(index+1);
                         }
                      });

                      logger.d("HEREL: ${classInfo.classId}");

                      await classController.addClassMember("6", classInfo.classId, checkedIndex);

                      classPlayStatusController.addClassExercise(classInfo.classId)
                      .then((value)  {
                        _isChecked.asMap().forEach((index, value) async {
                          if (value) {
                            await memberPlayStatusController.addMemberClassExercise(
                              classInfo.classId,
                              memberController.listMember[index].memberId,
                              memberController.listMember[index].name
                            );
                          }
                        });

                        Get.toNamed("/");
                      });
                    }
                )
              ],
            )
      ),
    ));
  }
}
