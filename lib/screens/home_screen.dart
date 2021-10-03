import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  late CupertinoTabView _returnValue;
  final CupertinoTabController _controller = CupertinoTabController();

  void _onItemTapped(int index) {
    if (index == 1) {
      _controller.index = _currentTabIndex;
      showCupertinoModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) => PlannerScreen(),
      );
    } else {
      _currentTabIndex = index;
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
        currentIndex: _currentTabIndex,
        onTap: _onItemTapped,
      ),
      controller: _controller,
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            _returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ListScreen(),
              );
            });
            break;
          case 1:
            break;
          case 2:
            _returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: DishesScreen(),
              );
            });
            break;
        }
        return _returnValue;
      },
    );
  }
}
