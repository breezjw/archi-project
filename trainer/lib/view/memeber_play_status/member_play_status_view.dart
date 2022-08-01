import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/member_play_status_controller.dart';
import 'package:trainer/view/class_list/class_list_view.dart';
import 'package:trainer/view/class_play/member_play_status_list_view.dart';
import 'package:trainer/view/common/common_widgets.dart';
import 'package:trainer/view/common/util.dart';

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
  MemberPlayStatusController memberPlayStatusController = Get.find<MemberPlayStatusController>();

  int memberWorkoutSpeed = 5;
  int memberWorkoutStrength = 5;
  int memberWorkoutCount = 10;

  @override
  void initState() {
    memberPlayStatusController.getMemberPlayStatus(widget.docId);
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
      body: Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: memberPlayStatusController.memberPlayStatus == null
            ? const Center(child: CircularProgressIndicator())
            :Column(
              children: [
                buildTitleText(text:"Member Info"),
                buildNormalText(text: "Name: ${memberPlayStatusController.memberPlayStatus!.name}"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text(
                    "Workout Status: ${memberPlayStatusController.memberPlayStatus!.workoutStatus.toUpperCase()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: workoutStatusColor[memberPlayStatusController.memberPlayStatus!.workoutStatus],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Member GEMS Info"),
                buildNormalText(text: "Speed: ${memberPlayStatusController.memberPlayStatus!.speed.values.last}"),
                buildNormalText(text: "Strength: ${memberPlayStatusController.memberPlayStatus!.strength.values.last}"),
                buildNormalText(text: "Count: ${memberPlayStatusController.memberPlayStatus!.count.values.last}"),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Member GEMS Control"),
                buildDropdownButton(
                    label: "Workout Speed",
                    initialValue: memberWorkoutSpeed.toString(),
                    callback: (value) {
                      setState(() {
                        _logger.d(value);
                        memberWorkoutSpeed = int.parse(value!);
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
                    label: "Workout Count",
                    range: 20,
                    initialValue: memberWorkoutCount.toString(),
                    callback: (value) {
                      setState(() {
                        _logger.d(value);
                        memberWorkoutCount = int.parse(value!);
                      });
                    }),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      var memberPlayStatus = memberPlayStatusController.memberPlayStatus;
                      memberPlayStatus!.controlSpeed = memberWorkoutSpeed;
                      memberPlayStatus.controlCount = memberWorkoutCount;
                      memberPlayStatus.controlStrength = memberWorkoutStrength;

                      memberPlayStatusController.updateMemberPlayStatus(memberPlayStatus);
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
        )
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
