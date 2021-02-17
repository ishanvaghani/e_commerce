import 'package:e_commerce/tabs/home_tab.dart';
import 'package:e_commerce/tabs/saved_tab.dart';
import 'package:e_commerce/tabs/search_tab.dart';
import 'package:e_commerce/widgets/bottom_tabs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _tabsPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Expanded(
            child: PageView(
              controller: _tabsPageController,
              onPageChanged: (num) {
                setState(() {
                  _selectedTab = num;
                });
                _tabsPageController.animateToPage(
                  num,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                );
              },
              children: [
                HomeTab(),
                SearchTab(),
                SavedTab(),
              ],
            ),
          ),
        ),
        BottomTabs(
          selectedTab: _selectedTab,
          tabPressed: (num) {
            setState(() {
              _tabsPageController.animateToPage(
                num,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
              );
            });
          },
        ),
      ],
    ));
  }
}
