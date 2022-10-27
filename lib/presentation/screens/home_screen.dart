import 'package:flutter/cupertino.dart';
import 'package:madplan_app/blocs/dish/dish_bloc.dart';
import 'package:madplan_app/data/repositories/database_repository.dart';
import 'package:madplan_app/data/services/service_locator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  late CupertinoTabView _returnValue;
  final CupertinoTabController _controller = serviceLocator<CupertinoTabController>();

  void _onItemTapped(int index) {
    if (index == 1) {
      _controller.index = _currentTabIndex;
      showCupertinoModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) => const PlannerScreen(),
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
            icon: const Icon(CupertinoIcons.list_bullet),
            label: ScreenConstants.list.title,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.plus),
            label: ScreenConstants.planner.title,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.table),
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
              return const CupertinoPageScaffold(
                child: ListScreen(),
              );
            });
            break;
          case 1:
            break;
          case 2:
            _returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: DishScreen(),
              );
            });
            break;
        }
        return _returnValue;
      },
    );
  }
}
