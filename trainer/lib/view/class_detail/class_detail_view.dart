import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/controller/class_play_status_controller.dart';
import 'package:trainer/view/class/class_list_view.dart';
import 'package:trainer/view/common/common_widgets.dart';

import '../class_play/class_play_view.dart';

class ClassDetailView extends StatefulWidget {
  static const routeName = '/class';

  const ClassDetailView({Key? key}) : super(key: key);

  @override
  _ClassDetailViewState createState() => _ClassDetailViewState();
}

class _ClassDetailViewState extends State<ClassDetailView>
    with SingleTickerProviderStateMixin{

  final Logger logger = Logger();

  final AuthController _authController = Get.find<AuthController>();
  ClassPlayStatusController classPlayStatusController = Get.find<ClassPlayStatusController>();

  static const int _numTabs = 3;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _numTabs, vsync: this);
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
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Expanded(child: Text("sfsdfsd")),
              buildButton(
                buttonText: "START WORKOUT",
                onPressed: () {
                  classPlayStatusController.addClassPlayStatus("classId")
                  .then((value) => Get.toNamed(ClassPlayView.routeName, arguments: value));
                }
              )
            ],
          )
      ),
    );
  }

  Tab _bottomTab(int index, IconData selected, IconData unselected, {color}) {
    bool isSelected = _tabController?.index == index;
    return Tab(
        icon: Icon(
          isSelected ? selected : unselected, color: color ?? Colors.black,));
  }
}
