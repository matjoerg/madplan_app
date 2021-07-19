import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(ScreenConstants.planner.title),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 50,
            ),
            Material(
              child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSearchBox: true,
                  showClearButton: true,
                  showSelectedItem: true,
                  items: ["Brazil", "Italia", "Tunisia", 'Canada'],
                  label: "Mandag",
                  hint: "country in menu mode",
                  onChanged: print,
                  selectedItem: "Brazil"),
            ),
            Container(
              color: Colors.transparent,
              height: 500,
            ),
          ],
        ),
      ),
    );
  }
}
