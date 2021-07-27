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
  String chosenDishName = "";
  bool _creatingNewDish = false;
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
        SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            children: [
              _buildDropDown("Valgt ret 1"),
              _buildDropDown("Valgt ret 2"),
              _buildDropDown("Valgt ret 3"),
              _buildDropDown("Valgt ret 4"),
            ],
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
        onChanged: _setDishName,
        dropdownBuilder: _customDropDown,
      ),
    );
  }

  Widget _customDropDown(BuildContext context, String? selectedItem, String? notUsed) {
    if (selectedItem == "Opret ny") {
      return CupertinoTextField(
        placeholder: "Navn på ny ret",
        controller: _newDishNameController,
      );
    } else {
      _newDishNameController.clear();
    }
    if (selectedItem == null) {
      return Text(
        "Vælg en ret eller opret en ny",
        style: TextStyle(color: CupertinoColors.placeholderText),
      );
    }

    return Text(selectedItem);
  }

  _setDishName(dynamic selectedItem) {
    if (selectedItem == "Opret ny") {
      _creatingNewDish = true;
    } else {
      _creatingNewDish = false;
      chosenDishName = selectedItem;
      print(selectedItem);
    }
  }
}
