import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/view/class/class_list_view.dart';
import 'package:trainer/view/class_play/member_play_status_list_view.dart';

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

  static const int _numTabs = 3;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _numTabs, vsync: this);
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
      body: MemberPlayStatusListView(),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton (
          child: Text('Stop Workout'),
          style: ElevatedButton.styleFrom(
              primary: Colors.red, // background
              onPrimary: Colors.white, // foreground
          ),
          onPressed: () {
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: '',
        child: const Icon(Icons.add),
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
