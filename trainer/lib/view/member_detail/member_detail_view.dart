import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/gems_controller.dart';
import 'package:trainer/controller/member_play_status_controller.dart';
import 'package:trainer/view/class_list/class_list_view.dart';
import 'package:trainer/view/class_play/member_play_status_list_view.dart';
import 'package:trainer/view/common/common_widgets.dart';
import 'package:trainer/view/common/util.dart';

class MemberDetailView extends StatefulWidget {
  static const routeName = '/member_detail';

  final String docId = Get.arguments;

  MemberDetailView({Key? key}) : super(key: key);

  @override
  _MemberDetailViewState createState() => _MemberDetailViewState();
}

class _MemberDetailViewState extends State<MemberDetailView>
    with SingleTickerProviderStateMixin{

  final Logger logger = Logger();

  final AuthController _authController = AuthController.to;
  MemberPlayStatusController memberPlayStatusController = Get.find<MemberPlayStatusController>();
  GemsController gemsController = Get.find<GemsController>();

  int memberWorkoutSpeed = 5;
  int memberWorkoutStrength = 5;
  int memberWorkoutCount = 10;

  int checkedGems = -1;

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
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Assigned GEMS"),
                buildNormalText(text:"None"),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Available GEMS"),
                Expanded(
                    child: ListView.builder(
                      itemCount: gemsController.listGems.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text("${gemsController.listGems[index].name} (${gemsController.listGems[index].id})"),
                          value: index == checkedGems ? true : false,
                          onChanged: (bool? value) {
                            setState(() {
                              logger.d("$index: ${value}");
                              checkedGems = value == true ? index : -1;
                            });
                          },
                        );
                      },
                    )
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
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
                        "ASSIGN GEMS",
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
