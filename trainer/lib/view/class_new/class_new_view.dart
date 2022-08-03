import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/class_play_status_controller.dart';
import 'package:trainer/controller/member_controller.dart';
import 'package:trainer/service/backend/member_service.dart';
import 'package:trainer/view/class_list/class_list_view.dart';
import 'package:trainer/view/class_new/member_new_list_item.dart';
import 'package:trainer/view/common/common_widgets.dart';

import '../class_play/class_play_view.dart';

class ClassNewView extends StatefulWidget {
  static const routeName = '/class_new';

  const ClassNewView({Key? key}) : super(key: key);

  @override
  _ClassNewViewState createState() => _ClassNewViewState();
}

class _ClassNewViewState extends State<ClassNewView>
    with SingleTickerProviderStateMixin{

  final Logger logger = Logger();

  final AuthController _authController = AuthController.to;
  MemberController memberController = Get.find<MemberController>();
  ClassPlayStatusController classPlayStatusController = Get.find<ClassPlayStatusController>();

  late List<bool> _isChecked;
  TextEditingController classNameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(memberController.listMember.length, false);
  }

  @override
  Widget build(BuildContext context) {

    memberController.getMemberList();

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: memberController.listMember.length == 0
            ? const Center(child: CircularProgressIndicator())
            :Column(
              children: [
                buildTitleText(text:"Class Info"),
                buildTextField(label: "Class Name", controller: classNameTextController),
                buildTextField(label: "Workout Type"),
                Container(padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
                buildTitleText(text:"Class Member"),
                Expanded(
                  child: ListView.builder(
                    itemCount: memberController.listMember.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(memberController.listMember[index].name),
                        value: _isChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            logger.d("$index: ${value}");
                            _isChecked[index] = value!;
                          });
                        },
                      );
                    },
                  )
                ),
                buildButton(
                    buttonText: "ADD CLASS",
                    onPressed: () {
                      classPlayStatusController.addClassPlayStatus(classNameTextController.text)
                      .then((value) => Get.toNamed("/"));
                    }
                )
              ],
            )
      ),
    ));
  }
}
