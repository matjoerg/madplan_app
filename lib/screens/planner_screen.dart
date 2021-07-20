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
        leading: TextButton(
          child: Text('Annuller'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: TextButton(
          child: Text('Opret'),
          onPressed: () {},
        ),
        middle: Text(ScreenConstants.planner.title),
      ),
      child: Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: 50,
                ),
                buildDropDown('Mandag'),
                SizedBox(height: 10),
                buildDropDown('Tirsdag'),
                SizedBox(height: 10),
                buildDropDown('Onsdag'),
                SizedBox(height: 10),
                buildDropDown('Torsdag'),
                SizedBox(height: 10),
                buildDropDown('Fredag'),
                SizedBox(height: 10),
                buildDropDown('Lørdag'),
                SizedBox(height: 10),
                buildDropDown('Søndag'),
                Container(
                  color: Colors.transparent,
                  height: 500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildDropDown(String title) {
    return DropdownSearch<String>(
      mode: Mode.MENU,
      showSearchBox: true,
      showClearButton: true,
      showSelectedItem: true,
      items: ["Brazil", "Italia", "Tunisia", 'Canada'],
      label: title,
      hint: "Vælg en ret",
      onChanged: print,
    );
  }
}
