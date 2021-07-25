import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({Key? key}) : super(key: key);

  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  String? newDishName;
  TextEditingController _newDishNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(ScreenConstants.database.title),
        ),
        SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                _buildDropDown("Valgt ret"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildDropDown(String title) {
    return Material(
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSearchBox: true,
        showClearButton: true,
        showSelectedItem: true,
        items: ["Opret ny", "Italia", "Tunisia", 'Canada'],
        label: title,
        onChanged: print,
        dropdownBuilder: _customDropDown,
      ),
    );
  }

  Widget _customDropDown(BuildContext context, String? selectedItem, String? notUsed) {
    //_newDishNameController.clear();
    if (selectedItem == "Opret ny") {
      return CupertinoTextField(
        placeholder: "Navn på ny ret",
        controller: _newDishNameController,
        onSubmitted: (value) {
          newDishName = value;
        },
      );
    }
    if (selectedItem == null) {
      return Text(
        "Vælg en ret eller opret ny",
        style: TextStyle(color: CupertinoColors.placeholderText),
      );
    }

    return Text(selectedItem);
  }
}
