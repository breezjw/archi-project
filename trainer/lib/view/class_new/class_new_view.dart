import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/class_play_status_controller.dart';
import 'package:trainer/controller/member_controller.dart';
import 'package:trainer/service/backend/member_service.dart';
import 'package:trainer/view/class_list/class_list_view.dart';
import 'package:trainer/view/class_new/member_list_item.dart';
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

  final AuthController _authController = Get.find<AuthController>();
  MemberController memberController = Get.find<MemberController>();

  late List<bool> _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(memberController.listMember.length, false);
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: memberController.listMember.isEmpty
            ? const Center(child: CircularProgressIndicator())
            :Column(
              children: [
                buildTextField(label: "Class Name"),
                buildTextField(label: "Workout Type"),
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
                    }
                )
              ],
            )
      ),
    ));
  }
}
