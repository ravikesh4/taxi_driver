import 'package:drive_app/tabsPages/earning_tab_page.dart';
import 'package:drive_app/tabsPages/home_tab_page.dart';
import 'package:drive_app/tabsPages/profile_tab_pages.dart';
import 'package:drive_app/tabsPages/rating_tab_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectIndex = index;
      tabController.index = selectIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          MainTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Earning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Rating',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.yellow,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12),
        showUnselectedLabels: true,
        currentIndex: selectIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
