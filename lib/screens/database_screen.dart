import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/constants/pixels.dart';
import 'package:madplan_app/models/dish.dart';
import 'package:madplan_app/models/item.dart';

import 'screens.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({Key? key}) : super(key: key);

  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  Dish? chosenDish;
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
        ),
        SliverPadding(
          padding: EdgeInsets.all(Pixels.defaultMargin),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                _buildAddButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildDishDropdown(String title) {
    return Material(
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSearchBox: true,
        showClearButton: false,
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
    if (chosenDish == null) {
      return ingredientsList;
    }
    int index = 0;
    chosenDish!.ingredients.forEach((ingredient) {
      ingredientsList.add(_buildIngredientDropdowns(ingredient, index));
      index++;
    });
    return ingredientsList;
  }

  Widget _buildAddButtons() {
    return Row(
      children: [
        if (chosenDish != null)
          CupertinoButton(
            child: Icon(CupertinoIcons.add_circled_solid),
            onPressed: () {
              setState(
                () {
                  chosenDish?.ingredients.add(Item(name: "Empty", category: "Empty"));
                },
              );
            },
          ),
        TextButton(
          child: Text("Ny vare"),
          onPressed: () => {},
        ),
        TextButton(
          child: Text("Ny kategori"),
          onPressed: () => {},
        ),
      ],
    );
  }

  Widget _buildIngredientDropdowns(Item ingredient, int index) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSearchBox: true,
                showClearButton: false,
                showSelectedItem: true,
                dropdownButtonBuilder: (_) => SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: ["Italia", "Tunisia", 'Canada'],
                label: "Vare " + index.toString(),
                onChanged: _setIngredientName,
                dropdownBuilder: _customIngredientDropdown,
              ),
            ),
            Expanded(
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSearchBox: false,
                showClearButton: false,
                showSelectedItem: true,
                dropdownButtonBuilder: (_) => SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: ["1", "2", "3", "99"],
                label: "Antal",
                onChanged: _setIngredientCount,
                dropdownBuilder: _customIngredientDropdown,
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSearchBox: true,
                showClearButton: false,
                showSelectedItem: true,
                dropdownButtonBuilder: (_) => SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: ["Italia", "Tunisia", 'Canada'],
                label: "Kategori",
                onChanged: _setIngredientCategory,
                dropdownBuilder: _customIngredientDropdown,
              ),
            ),
            _buildRemoveIngredientButton(index),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveIngredientButton(int index) {
    return CupertinoButton(
        child: Icon(CupertinoIcons.clear_circled_solid),
        onPressed: () {
          setState(() {
            chosenDish?.ingredients.removeAt(index);
          });
        });
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
    if (selectedItem == null) {
      return Container();
    }

    return Text(selectedItem);
  }

  _setDishName(dynamic selectedItem) {
    if (selectedItem == null) {
      _creatingNewDish = false;
      setState(() {
        chosenDish = null;
      });
      return;
    }
    if (selectedItem == "Opret ny") {
      _creatingNewDish = true;
    } else {
      _creatingNewDish = false;
      setState(() {
        chosenDish = getDish(selectedItem);
      });
      print(selectedItem);
    }
  }

  Dish getDish(String dishName) {
    return Dish(
      name: dishName,
      ingredients: [
        Item(name: "Kartofler", category: "Frugt og grønt"),
        Item(name: "Mel", category: "Kolonial"),
      ],
    );
  }

  _setIngredientName(dynamic selectedItem) {
    if (selectedItem == null) {
      return;
    }
    if (selectedItem == "Opret ny") {
    } else {
      print(selectedItem);
    }
  }

  _setIngredientCount(dynamic selectedItem) {
    if (selectedItem == null) {
      return;
    } else {
      print(selectedItem);
    }
  }

  _setIngredientCategory(dynamic selectedItem) {
    if (selectedItem == null) {
      return;
    }
    if (selectedItem == "Opret ny") {
    } else {
      print(selectedItem);
    }
  }
}
