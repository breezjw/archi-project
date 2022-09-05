import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/authentication_manager/auth_controller.dart';
import 'package:trainer/data_manager/gems_data_manager.dart';
import 'package:trainer/data_manager/member_data_manager.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/ui/common/common_widgets.dart';

class MemberDetailView extends StatefulWidget {
  static const routeName = '/member_detail';

  final String memberId = Get.arguments;

  MemberDetailView({Key? key}) : super(key: key);

  @override
  _MemberDetailViewState createState() => _MemberDetailViewState();
}

class _MemberDetailViewState extends State<MemberDetailView>
    with SingleTickerProviderStateMixin{

  final Logger logger = Logger();

  final AuthController _authController = AuthController.to;
  MemberDataManager memberController = Get.find<MemberDataManager>();
  GemsDataManager gemsController = Get.find<GemsDataManager>();

  Member? member;

  int checkedGems = -1;

  @override
  void initState() {
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
          child: memberController.listMember.isEmpty
            ? const Center(child: CircularProgressIndicator())
            :Column(
              children: [
                buildTitleText(text:"Member Info"),
                buildNormalText(text: "Name: ${memberController.getMember(widget.memberId)!.name} (ID: ${memberController.getMember(widget.memberId)!.memberId})"),
                buildNormalText(text: "Age: ${memberController.getMember(widget.memberId)!.age.toString()}"),
                buildNormalText(text: "Gender: ${memberController.getMember(widget.memberId)!.gender}"),
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
                          title: Text("${gemsController.listGems[index].name} (${gemsController.listGems[index].gemsId})"),
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
                      logger.d("Assign GEMS: ${gemsController.listGems[checkedGems].gemsId}");
                      setState(() async {
                        await gemsController.assignGems("6", widget.memberId, gemsController.listGems[checkedGems].gemsId);
                        await gemsController.getGemsList("6");
                        checkedGems = -1;
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
