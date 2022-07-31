import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/bluetooth_controller.dart';
import 'package:trainer/controller/class_play_status_controller.dart';
import 'package:trainer/controller/member_all_controller.dart';
import 'package:trainer/controller/member_play_status_controller.dart';
import 'package:trainer/view/class_list/class_list_view.dart';
import 'package:trainer/view/class_play/member_play_status_list_view.dart';

class MemberMainView extends StatefulWidget {
  static const routeName = '/member_main';

  //final String docId = Get.arguments;
  final String docId = "aaa"; //member docId
  final String trainerClassId = "classId"; // class ID

  const MemberMainView({Key? key}) : super(key: key);

  @override
  _MemberPlayStatusViewState createState() => _MemberPlayStatusViewState();
}

class _MemberPlayStatusViewState extends State<MemberMainView>
    with SingleTickerProviderStateMixin {
  final Logger _logger = Logger();

  //final AuthController _authController = AuthController.to;

  MemberAllController memberAllController = Get.find<MemberAllController>();
  //ClassPlayStatusController classPlayStatusController = Get.find<ClassPlayStatusController>();

  @override
  void initState() {
    _logger.d("member main view");
    memberAllController.getMemberPlayStatus(widget.docId); // member ID
    //classPlayStatusController.getClassPlayStatus(widget.docClassId);
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    // ClassController classController = Get.find<ClassController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("GEMS Member"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () {
                //_authController.handleSignOut();
              },
            )
          ],
        ),
      ),
      body: Obx(() => Container(
          child: memberAllController.memberPlayStatus == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    const Divider(
                      thickness: 1,
                      indent: 8,
                      endIndent: 8,
                      color: Colors.grey,
                    ),
                    ListTile(
                      title: const Text('My Status',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      subtitle: Text("Name : " +
                          memberAllController.memberPlayStatus!.name +
                          "\n" +
                          "Trainer : xxx" +
                          "\n" +
                          "Group : xxx"),
                    ),
                    ListTile(
                      title: const Text('Workout Information'),
                      subtitle: Text(
                          "Count: ${memberAllController.memberPlayStatus!.count}" +
                              "\n" +
                              "Total Time : 0h 0m 0s"),
                    ),
                    const Divider(
                      thickness: 1,
                      indent: 8,
                      endIndent: 8,
                      color: Colors.grey,
                    ),
                    ListTile(
                      title: const Text('GEMS',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      trailing: ElevatedButton(
                        child: const Text('Scan / Connect'),
                        onPressed: () {
                          memberAllController.showDevicePicker();
                        },
                      ),
                    ),
                    ListTile(
                      //title: Text("selected GEMS device"),
                      title: Text(
                          memberAllController.rxstr_selected_device.string),
                    ),
                    ListTile(
                      title: Text("Workout : " +
                          memberAllController.rxstr_workout_mode.string),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            child: const Text('Start'),
                            onPressed: () {
                              memberAllController.rxstr_workout_mode('Start');
                              memberAllController.setWorkoutMode(1);

                              var memberPlayStatus =
                                  memberAllController.memberPlayStatus;
                              memberAllController
                                  .startRecording(memberPlayStatus!);

                              // setState(() {
                              //   _workout_mode = 1;
                              //   _str_workout_mode = "Start";
                              //   _count = 0;
                              //   _str_count = "Count : 0";
                              //   _total_time = 0;
                              //   _str_total_time = "Total Time : 0h 0m 0s";
                              //   setWorkoutMode(_workout_mode);
                              // });
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                          ),
                          ElevatedButton(
                            child: const Text('Stop'),
                            onPressed: () {
                              memberAllController.rxstr_workout_mode('Stop');
                              memberAllController.setWorkoutMode(0);

                              var memberPlayStatus =
                                  memberAllController.memberPlayStatus;
                              memberAllController
                                  .stopRecording(memberPlayStatus!);

                              // setState(() {
                              //   _str_workout_mode = "Stop";
                              //   _workout_mode = 0;
                              //   setWorkoutMode(_workout_mode);
                              // });
                            },
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                          "Strength(0~10) : ${memberAllController.memberPlayStatus!.strength}"),
                      enabled: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            child: const Text('+'),
                            onPressed: () {
                              var memberPlayStatus =
                                  memberAllController.memberPlayStatus;
                              if (memberPlayStatus!.strength < 10) {
                                memberPlayStatus.strength++;
                                memberAllController
                                    .updateMemberPlayStatus(memberPlayStatus);
                              }
                              memberAllController
                                  .setStrength(memberPlayStatus.strength);
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                          ),
                          ElevatedButton(
                            child: const Text('-'),
                            onPressed: () {
                              var memberPlayStatus =
                                  memberAllController.memberPlayStatus;
                              if (memberPlayStatus!.strength > 0) {
                                memberPlayStatus.strength--;
                                memberAllController
                                    .updateMemberPlayStatus(memberPlayStatus);
                              }
                              memberAllController
                                  .setStrength(memberPlayStatus.strength);
                            },
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                          "Speed(0~10) : ${memberAllController.memberPlayStatus!.speed}"),
                      enabled: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            child: const Text('+'),
                            onPressed: () {
                              var memberPlayStatus =
                                  memberAllController.memberPlayStatus;
                              if (memberPlayStatus!.speed < 10) {
                                memberPlayStatus.speed++;
                                memberAllController
                                    .updateMemberPlayStatus(memberPlayStatus);
                              }
                              memberAllController
                                  .setSpeed(memberPlayStatus.speed);
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                          ),
                          ElevatedButton(
                            child: const Text('-'),
                            onPressed: () {
                              var memberPlayStatus =
                                  memberAllController.memberPlayStatus;
                              if (memberPlayStatus!.speed > 0) {
                                memberPlayStatus.speed--;
                                memberAllController
                                    .updateMemberPlayStatus(memberPlayStatus);
                              }
                              memberAllController
                                  .setSpeed(memberPlayStatus.speed);
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    /////////////////////////////////////////
                    Text("[BT-Rx] " +
                        memberAllController.rxstr_received_data.string),
                    Text(memberAllController.memberPlayStatus!.name),
                    Text(
                        "Strength: ${memberAllController.memberPlayStatus!.strength}"),
                    Text(
                        "Count: ${memberAllController.memberPlayStatus!.count}"),
                    Text(
                        "Speed: ${memberAllController.memberPlayStatus!.speed}"),
                    // Text(
                    //     "status: " +classPlayStatusController.classPlayStatus!.status),
                    ElevatedButton(
                        onPressed: () {
                          var memberPlayStatus =
                              memberAllController.memberPlayStatus;

                          Random random = Random();
                          memberPlayStatus!.speed = random.nextInt(10);
                          memberPlayStatus.count = random.nextInt(10);
                          memberPlayStatus.strength = random.nextInt(10);

                          memberAllController
                              .updateMemberPlayStatus(memberPlayStatus);

                          //for bluetooth
                          memberAllController
                              .setStrength(memberPlayStatus.strength);
                          memberAllController.setSpeed(memberPlayStatus.speed);
                        },
                        child: Text("Update"))
                  ],
                ))),
    );
  }
}
