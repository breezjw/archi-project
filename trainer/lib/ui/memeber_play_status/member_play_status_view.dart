import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/authentication_manager/auth_controller.dart';
import 'package:trainer/exercise_controller/member_class_exercise_controller.dart';
import 'package:trainer/ui/common/common_widgets.dart';
import 'package:trainer/ui/common/util.dart';

class MemberPlayStatusView extends StatefulWidget {
  static const routeName = '/member_play_status';

  final String docId = Get.arguments;

  MemberPlayStatusView({Key? key}) : super(key: key);

  @override
  _MemberPlayStatusViewState createState() => _MemberPlayStatusViewState();
}

class _MemberPlayStatusViewState extends State<MemberPlayStatusView>
    with SingleTickerProviderStateMixin{

  final Logger _logger = Logger();

  final AuthController _authController = AuthController.to;
  MemberClassExerciseController memberPlayStatusController = Get.find<MemberClassExerciseController>();

  int memberWorkoutSpeed = 5;
  int memberWorkoutStrength = 5;
  int memberWorkoutCount = 100;

  @override
  void initState() {
    // memberPlayStatusController.getMemberClassExercise(widget.docId).then((value) {
    //   setState(() {
    //     memberWorkoutSpeed = memberPlayStatusController.memberPlayStatus!.controlSpeed;
    //     memberWorkoutStrength = memberPlayStatusController.memberPlayStatus!.controlStrength;
    //     memberWorkoutCount = memberPlayStatusController.memberPlayStatus!.controlCount;
    //   });
    // });

    var member = memberPlayStatusController.listMemberPlayStatus.firstWhere((
        element) => element.memberClassExerciseId == widget.docId);

    setState(() {
      memberWorkoutSpeed = member!.controlSpeed;
      memberWorkoutStrength = member!.controlStrength;
      memberWorkoutCount = member!.controlCount;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // ClassController classController = Get.find<ClassController>();

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
      body: Obx(() {
        // var memberPlayStatus = memberPlayStatusController.memberPlayStatus;
        // var lastCount = memberPlayStatus!.count[(memberPlayStatus!.count.length-1)];
        // var lastSpeed = memberPlayStatus.speed[(memberPlayStatus.speed.length-1)];
        // var lastStrength = memberPlayStatus.strength[(memberPlayStatus.strength.length-1)];

        var member = memberPlayStatusController.listMemberPlayStatus.firstWhere((
            element) => element.memberClassExerciseId == widget.docId);

        var lastCount = member!.count[(member!.count.length-1)];
        var lastSpeed = member.speed[(member.speed.length-1)];
        var lastStrength = member.strength[(member.strength.length-1)];

        _logger.d(memberWorkoutCount);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child:
            Column(
              children: [
                buildTitleText(text:"Member Info"),
                buildNormalText(text: "Name: ${member!.name}"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text(
                    "Exercise Status: ${member!.exerciseStatus.toUpperCase()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: workoutStatusColor[member!.exerciseStatus],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Member GEMS Info"),
                buildNormalText(text: "Count: ${
                    member!.count.isEmpty ?
                    0 : lastCount
                }"),
                buildNormalText(text: "Strength: ${
                    member!.strength.isEmpty ?
                    0 : lastStrength
                }"),
                buildNormalText(text: "Speed: ${
                    member!.speed.isEmpty ?
                    0 : lastSpeed
                }"),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Member GEMS Control"),
                buildDropdownButton(
                    label: "Workout Count",
                    range: 20,
                    interval: 10,
                    initialValue: memberWorkoutCount.toString(),
                    callback: (value) {
                      setState(() {
                        _logger.d(value);
                        memberWorkoutCount = int.parse(value!);
                      });
                    }),
                buildDropdownButton(
                    label: "Workout Strength",
                    initialValue: memberWorkoutStrength.toString(),
                    callback: (value) {
                      setState(() {
                        _logger.d(value);
                        memberWorkoutStrength = int.parse(value!);
                      });
                    }),
                buildDropdownButton(
                    label: "Workout Speed",
                    initialValue: memberWorkoutSpeed.toString(),
                    callback: (value) {
                      setState(() {
                        _logger.d(value);
                        memberWorkoutSpeed = int.parse(value!);
                      });
                    }),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // var memberPlayStatus = memberPlayStatusController.memberPlayStatus;
                      member!.controlSpeed = memberWorkoutSpeed;
                      member.controlCount = memberWorkoutCount;
                      member.controlStrength = memberWorkoutStrength;

                      memberPlayStatusController.updateMemberClassExercise(member);
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
            ],
          )
        );}
      ),
      // bottomSheet: Container(
      //   width: MediaQuery.of(context).size.width,
      //   child: ElevatedButton (
      //     child: Text('Stop Workout'),
      //     style: ElevatedButton.styleFrom(
      //         primary: Colors.red, // background
      //         onPrimary: Colors.white, // foreground
      //     ),
      //     onPressed: () {
      //     },
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: '',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  // Tab _bottomTab(int index, IconData selected, IconData unselected, {color}) {
  //   bool isSelected = _tabController?.index == index;
  //   return Tab(
  //       icon: Icon(
  //         isSelected ? selected : unselected, color: color ?? Colors.black,));
  // }
}
