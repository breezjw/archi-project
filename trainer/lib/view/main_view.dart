import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/auth_controller.dart';
import 'package:trainer/view/class/class_list_view.dart';

class MainView extends StatefulWidget {
  static const routeName = '/';

  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
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
      bottomNavigationBar: Material(
          color: Colors.white,
          elevation: 10,
          child: TabBar(
            controller: _tabController,
            tabs: [
              _bottomTab(0, Icons.home, Icons.home_outlined),
              _bottomTab(1, Icons.library_books, Icons.library_books_outlined),
              _bottomTab(2, Icons.person, Icons.person_outlined),
            ],
            onTap: (index) => setState((){}),
          )
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ClassListView(),
          const Placeholder(),
          const Placeholder(),
        ],
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
