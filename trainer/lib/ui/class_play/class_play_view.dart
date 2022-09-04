import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/authentication_manager/auth_controller.dart';
import 'package:trainer/exercise_controller/class_exercise_controller.dart';
import 'package:trainer/exercise_controller/member_class_exercise_controller.dart';
import 'package:trainer/model/class_info.dart';
import 'package:trainer/ui/class_detail/class_detail_view.dart';
import 'package:trainer/ui/class_play/member_play_status_list_view.dart';
import 'package:trainer/ui/common/common_widgets.dart';

class ClassPlayView extends StatefulWidget {
  static const routeName = '/class_play';

  const ClassPlayView({Key? key}) : super(key: key);

  @override
  _ClassPlayViewState createState() => _ClassPlayViewState();
}

class _ClassPlayViewState extends State<ClassPlayView>
    with SingleTickerProviderStateMixin{

  final Logger logger = Logger();

  final AuthController _authController = AuthController.to;
  ClassExerciseController classPlayStatusController = Get.find<ClassExerciseController>();
  MemberClassExerciseController memberPlayStatusController = Get.find<MemberClassExerciseController>();

  final ClassInfo classInfo = Get.arguments["classInfo"];
  final int playCount = int.parse(Get.arguments["playCount"]);

  int classWorkoutSpeed = 5;
  int classWorkoutStrength = 5;
  int classWorkoutCount = 10;

  @override
  void initState() {
    logger.d(classInfo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // ClassController classController = Get.find<ClassController>();
    classPlayStatusController.bindClassExercise(classInfo.classId);
    memberPlayStatusController.getListMemberClassExercise(classInfo.classId, playCount);

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
                buildTitleText(text:"\"${classInfo.name}\" Class #$playCount"),
                buildNormalText(text: "Exercise Type: Diet Class"),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Class GEMS Control"),
                buildDropdownButton(
                  label: "Exercise Speed",
                  initialValue: classWorkoutSpeed.toString(),
                  callback: (value) {
                    setState(() {
                      logger.d(value);
                      classWorkoutSpeed = int.parse(value!);
                    });
                }),
                buildDropdownButton(
                  label: "Exercise Strength",
                  initialValue: classWorkoutStrength.toString(),
                  callback: (value) {
                    setState(() {
                      logger.d(value);
                      classWorkoutStrength = int.parse(value!);
                    });
                }),
                buildDropdownButton(
                  label: "Exercise Count",
                  range: 20,
                  initialValue: classWorkoutCount.toString(),
                  callback: (value) {
                    setState(() {
                      logger.d(value);
                      classWorkoutCount = int.parse(value!);
                    });
                }),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      memberPlayStatusController.listMemberPlayStatus.forEach((element) {
                        var memberPlayStatus = element;
                        memberPlayStatus.controlSpeed = classWorkoutSpeed;
                        memberPlayStatus.controlCount = classWorkoutStrength;
                        memberPlayStatus.controlStrength = classWorkoutCount;

                        logger.d(memberPlayStatus.toJson());

                        memberPlayStatusController.updateMemberClassExercise(memberPlayStatus);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,//change background color of button
                      onPrimary: Colors.blue,//change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 15.0,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(
                        "SET GEMS",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),

                  ),
                ),
                Container(padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),),
                buildTitleText(text:"Member Workout Status"),
                Expanded(child: MemberPlayStatusListView()),
                buildButton(
                  buttonText: "STOP WORKOUT",
                  onPressed: () {
                    // Get.toNamed(ClassPlayView.routeName, arguments: "test");
                    classPlayStatusController.stopClassExercise(classInfo.classId)
                    .then((value) => Get.toNamed(ClassDetailView.routeName, arguments: classInfo));
                  },
                  backgroundColor: Colors.red
                )
              ],
            )
        ),
      )
    );
  }
}
