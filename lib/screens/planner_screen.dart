import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/components/search_decoration.dart';
import 'package:madplan_app/constants/pixels.dart';

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
            padding: const EdgeInsets.all(Pixels.defaultMargin),
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: 50,
                ),
                _buildDropdown('Mandag'),
                SizedBox(height: 10),
                _buildDropdown('Tirsdag'),
                SizedBox(height: 10),
                _buildDropdown('Onsdag'),
                SizedBox(height: 10),
                _buildDropdown('Torsdag'),
                SizedBox(height: 10),
                _buildDropdown('Fredag'),
                SizedBox(height: 10),
                _buildDropdown('Lørdag'),
                SizedBox(height: 10),
                _buildDropdown('Søndag'),
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

  _buildDropdown(String title) {
    return DropdownSearch<String>(
      mode: Mode.DIALOG,
      showSearchBox: true,
      searchFieldProps: TextFieldProps(decoration: SearchDecoration()),
      showClearButton: true,
      showSelectedItems: true,
      items: ["Brazil", "Italia", "Tunisia", 'Canada'],
      label: title,
      hint: "Vælg en ret",
      onChanged: print,
    );
  }
}
