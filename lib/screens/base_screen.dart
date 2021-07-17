import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/screens/database_screen.dart';
import 'package:madplan_app/screens/planner_screen.dart';
import 'package:madplan_app/screens/screen_constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'list_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentTabIndex = 0;
  late CupertinoTabView returnValue;
  final CupertinoTabController _controller = CupertinoTabController();

  void _onItemTapped(int index) {
    if (index == 1) {
      _controller.index = currentTabIndex;
      showCupertinoModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) => CupertinoPageScaffold(
          child: PlannerScreen(),
        ),
      );
    } else {
      currentTabIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: ScreenConstants.list.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.plus),
            label: ScreenConstants.planner.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.table),
            label: ScreenConstants.database.title,
          ),
        ],
        currentIndex: currentTabIndex,
        onTap: _onItemTapped,
      ),
      controller: _controller,
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ListScreen(),
              );
            });
            break;
          case 1:
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: DatabaseScreen(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}
