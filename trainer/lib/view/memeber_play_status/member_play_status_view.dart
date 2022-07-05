import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/member_play_status_controller.dart';
import 'package:trainer/view/class/class_list_view.dart';
import 'package:trainer/view/class_play/member_play_status_list_view.dart';

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

  final AuthController _authController = Get.find<AuthController>();
  MemberPlayStatusController memberPlayStatusController = Get.find<MemberPlayStatusController>();

  @override
  void initState() {
    _logger.d("sdlfnsdlfnsdlkfn");
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
      // bottomNavigationBar: Material(
      //     color: Colors.white,
      //     elevation: 10,
      //     child: TabBar(
      //       controller: _tabController,
      //       tabs: [
      //         _bottomTab(0, Icons.home, Icons.home_outlined),
      //         _bottomTab(1, Icons.library_books, Icons.library_books_outlined),
      //         _bottomTab(2, Icons.person, Icons.person_outlined),
      //       ],
      //       onTap: (index) => setState((){}),
      //     )
      // ),
      body: Obx(() => Container(
          child: memberPlayStatusController.memberPlayStatus == null
            ? const Center(child: CircularProgressIndicator())
            :Column(
              children: [
                Text(memberPlayStatusController.memberPlayStatus!.name),
                Text("Strength: ${memberPlayStatusController.memberPlayStatus!.strength}"),
                Text("Count: ${memberPlayStatusController.memberPlayStatus!.count}"),
                Text("Speed: ${memberPlayStatusController.memberPlayStatus!.speed}"),
                ElevatedButton(
                  onPressed: (){
                    var memberPlayStatus = memberPlayStatusController.memberPlayStatus;

                    Random random = Random();
                    memberPlayStatus!.speed = random.nextInt(10);
                    memberPlayStatus.count = random.nextInt(10);
                    memberPlayStatus.strength = random.nextInt(10);

                    memberPlayStatusController.updateMemberPlayStatus(memberPlayStatus);
                  },
                  child: Text("Update")
                )
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
