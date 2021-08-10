import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/constants/pixels.dart';

import 'screens.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({Key? key}) : super(key: key);

  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  String? chosenDishName;
  int noOfIngredients = 0;
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
          padding: EdgeInsets.all(Pixels.defaultMargin),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                _buildDishDropdown("Valgt ret"),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(Pixels.defaultMargin),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              _buildIngredients(),
            ),
          ),

          /*SliverGrid.count(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            children: [
              _buildDropDown("Valgt ret 1"),
              _buildDropDown("Valgt ret 2"),
              _buildDropDown("Valgt ret 3"),
              _buildDropDown("Valgt ret 4"),
            ],
          ),*/
        ),
      ],
    );
  }

  _buildDishDropdown(String title) {
    return Material(
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSearchBox: true,
        showClearButton: true,
        showSelectedItem: true,
        items: ["Opret ny", "Italia", "Tunisia", 'Canada'],
        label: title,
        onChanged: _setDishName,
        dropdownBuilder: _customDishDropdown,
      ),
    );
  }

  List<Widget> _buildIngredients() {
    List<Widget> ingredientsList = [];
    for (int i = 0; i < noOfIngredients; i++) {
      ingredientsList.add(_buildIngredientDropdowns("1"));
    }
    ingredientsList.add(_buildAddIngredientButton());
    return ingredientsList;
  }

  Widget _buildAddIngredientButton() {
    return CupertinoButton(
        child: Icon(CupertinoIcons.add_circled_solid),
        onPressed: () {
          setState(() {
            noOfIngredients++;
          });
        });
  }

  Widget _buildIngredientDropdowns(String title) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSearchBox: true,
                showClearButton: false,
                showSelectedItem: true,
                items: ["Opret ny", "Italia", "Tunisia", 'Canada'],
                label: "Vare " + title,
                onChanged: _setDishName,
                dropdownBuilder: _customIngredientDropdown,
              ),
            ),
            Expanded(
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSearchBox: false,
                showClearButton: false,
                showSelectedItem: true,
                items: ["1", "2", "3", "4"],
                label: "Antal",
                onChanged: _setDishName,
                dropdownBuilder: _customCountDropdown,
              ),
            ),
            Expanded(
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSearchBox: true,
                showClearButton: false,
                showSelectedItem: true,
                items: ["Opret ny", "Italia", "Tunisia", 'Canada'],
                label: "Kategori",
                onChanged: _setDishName,
                dropdownBuilder: _customCategoryDropdown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customDishDropdown(BuildContext context, String? selectedItem, String? notUsed) {
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

  Widget _customIngredientDropdown(BuildContext context, String? selectedItem, String? notUsed) {
    if (selectedItem == "Opret ny") {
      return CupertinoTextField(
        placeholder: "Navn på ny vare",
      );
    }
    if (selectedItem == null) {
      return Container();
    }

    return Text(selectedItem);
  }

  Widget _customCountDropdown(BuildContext context, String? selectedItem, String? notUsed) {
    if (selectedItem == null) {
      return Container();
    }

    return Text(selectedItem);
  }

  Widget _customCategoryDropdown(BuildContext context, String? selectedItem, String? notUsed) {
    if (selectedItem == "Opret ny") {
      return CupertinoTextField(
        placeholder: "Navn på ny kategori",
      );
    }
    if (selectedItem == null) {
      return Container();
    }

    return Text(selectedItem);
  }

  _setDishName(dynamic selectedItem) {
    if (selectedItem == null) {
      _creatingNewDish = false;
      chosenDishName = null;
      return;
    }
    if (selectedItem == "Opret ny") {
      _creatingNewDish = true;
    } else {
      _creatingNewDish = false;
      chosenDishName = selectedItem;
      print(selectedItem);
    }
  }
}
