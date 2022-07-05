import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/class_play_status_controller.dart';
import 'package:trainer/view/class/class_list_view.dart';
import 'package:trainer/view/class_detail/class_detail_view.dart';
import 'package:trainer/view/class_play/member_play_status_list_view.dart';
import 'package:trainer/view/common/common_widgets.dart';

class ClassPlayView extends StatefulWidget {
  static const routeName = '/class_play';

  const ClassPlayView({Key? key}) : super(key: key);

  @override
  _ClassPlayViewState createState() => _ClassPlayViewState();
}

class _ClassPlayViewState extends State<ClassPlayView>
    with SingleTickerProviderStateMixin{

  final Logger _logger = Logger();

  final AuthController _authController = Get.find<AuthController>();
  ClassPlayStatusController classPlayStatusController = Get.find<ClassPlayStatusController>();

  final String docId = Get.arguments;

  @override
  void initState() {
    classPlayStatusController.getClassPlayStatus(docId);

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
          child: classPlayStatusController.classPlayStatus == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
              children: [
                Expanded(child: MemberPlayStatusListView()),
                Text(classPlayStatusController.classPlayStatus!.trainerClassId),
                buildButton(
                  buttonText: "STOP WORKOUT",
                  onPressed: () {
                    // Get.toNamed(ClassPlayView.routeName, arguments: "test");
                    classPlayStatusController.stopClassPlayStatus(docId)
                    .then((value) => Get.toNamed(ClassDetailView.routeName, arguments: "test"));
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
