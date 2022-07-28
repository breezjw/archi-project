import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/class_play_status_controller.dart';
import 'package:trainer/view/class_detail/member_list_view.dart';
import 'package:trainer/view/class_list//class_list_view.dart';
import 'package:trainer/view/common/common_widgets.dart';

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
  ClassPlayStatusController classPlayStatusController = Get.find<ClassPlayStatusController>();

  final String classId = Get.arguments;

  @override
  void initState() {
    classPlayStatusController.bindClassPlayStatus(classId);

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
                buildNormalText(text: "Workout Type: Diet Class"),
                buildNormalText(text: "Workout Play Count: ${classPlayStatusController.classPlayStatus!.playCount.toString()}"),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Class Members"),
                Expanded(child: MemberListView()),
                buildButton(
                  buttonText: "START WORKOUT",
                  onPressed: () {
                    classPlayStatusController.startClassPlayStatus(classId)
                    .then((value) => Get.toNamed(ClassPlayView.routeName, arguments: classId));
                  }
                )
              ],
            )
        )
      ),
    );
  }

}
