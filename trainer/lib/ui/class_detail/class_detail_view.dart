import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/authentication_manager/auth_controller.dart';
import 'package:trainer/data_manager/class_data_manager.dart';
import 'package:trainer/data_manager/member_data_manager.dart';
import 'package:trainer/exercise_controller/class_exercise_controller.dart';
import 'package:trainer/model/class_info.dart';
import 'package:trainer/ui/class_detail/member_list_view.dart';
import 'package:trainer/ui/common/common_widgets.dart';

import '../class_play/class_play_view.dart';

class ClassDetailView extends StatefulWidget {
  static const routeName = '/class_list';

  const ClassDetailView({Key? key}) : super(key: key);

  @override
  _ClassDetailViewState createState() => _ClassDetailViewState();
}

class _ClassDetailViewState extends State<ClassDetailView>
    with SingleTickerProviderStateMixin{

  final Logger logger = Logger();

  final AuthController _authController = AuthController.to;
  ClassDataManager classController = Get.find<ClassDataManager>();
  ClassExerciseController classPlayStatusController = Get.find<ClassExerciseController>();
  MemberDataManager memberController = Get.find<MemberDataManager>();

  final String classId = Get.arguments;
  late ClassInfo? classInfo;

  @override
  void initState() {
    classInfo = classController.getClass(classId);
    classPlayStatusController.bindClassExercise(classId);
    memberController.getMemberList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: classPlayStatusController.classPlayStatus == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
              children: [
                buildTitleText(text: "Class Info"),
                buildNormalText(text: "Name: ${classInfo!.name} (ID: ${classInfo!.classId})"),
                buildNormalText(text: "Exercise Type: Diet Class"),
                buildNormalText(text: "Exercise Number: ${classPlayStatusController.classPlayStatus!.exerciseCount.toString()}"),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Class Members"),
                Expanded(child: MemberListView(classId: classId,)),
                buildButton(
                  buttonText: "START WORKOUT",
                  onPressed: () {
                    classPlayStatusController.startClassExercise(classId)
                    .then((value) => Get.toNamed(ClassPlayView.routeName,
                        arguments: {"classInfo": classInfo, "playCount": (classPlayStatusController.classPlayStatus!.exerciseCount+1).toString()}));
                  }
                )
              ],
            )
        )
      ),
    );
  }

}
