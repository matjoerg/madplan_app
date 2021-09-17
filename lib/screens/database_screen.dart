import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/constants/pixels.dart';
import 'package:madplan_app/models/dropdown_ingredient.dart';
import 'package:madplan_app/models/models.dart';

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
        items: ["Opret ny", "Ret", "Retteret", 'Ret med ret'],
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
      ingredientsList.add(_buildIngredientDropdownRow(ingredient, index));
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
                  chosenDish?.ingredients.add(Item(name: "", category: "", count: 0));
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

  Widget _buildIngredientDropdownRow(Item ingredient, int index) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownSearch<IndexedIngredientProperty>(
                mode: Mode.MENU,
                showSearchBox: true,
                showClearButton: false,
                showSelectedItem: true,
                dropdownButtonBuilder: (_) => SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: [
                  IndexedIngredientProperty(property: "Kartofler", index: index),
                  IndexedIngredientProperty(property: "Broccoli", index: index),
                  IndexedIngredientProperty(property: "Rød peber", index: index),
                ],
                itemAsString: (IndexedIngredientProperty item) => item.property,
                compareFn: _compareIngredientProperties,
                selectedItem: ingredient.name.isNotEmpty
                    ? IndexedIngredientProperty(property: ingredient.name, index: index)
                    : null,
                label: "Vare " + (index + 1).toString(),
                onChanged: _setIngredientName,
                dropdownBuilder: _customIngredientDropdown,
              ),
            ),
            Expanded(
              child: DropdownSearch<IndexedIngredientProperty>(
                mode: Mode.MENU,
                showSearchBox: false,
                showClearButton: false,
                showSelectedItem: true,
                dropdownButtonBuilder: (_) => SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: [
                  IndexedIngredientProperty(property: "1", index: index),
                  IndexedIngredientProperty(property: "21", index: index),
                  IndexedIngredientProperty(property: "91", index: index),
                  IndexedIngredientProperty(property: "99", index: index),
                ],
                itemAsString: (IndexedIngredientProperty item) => item.property,
                compareFn: _compareIngredientProperties,
                selectedItem: ingredient.count != 0
                    ? IndexedIngredientProperty(property: ingredient.count.toString(), index: index)
                    : null,
                label: "Antal",
                onChanged: _setIngredientCount,
                dropdownBuilder: _customIngredientDropdown,
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownSearch<IndexedIngredientProperty>(
                mode: Mode.MENU,
                showSearchBox: true,
                showClearButton: false,
                showSelectedItem: true,
                dropdownButtonBuilder: (_) => SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: [
                  IndexedIngredientProperty(property: "Frugt og grønt", index: index),
                  IndexedIngredientProperty(property: "Kolonial", index: index),
                  IndexedIngredientProperty(property: "Frost", index: index),
                ],
                itemAsString: (IndexedIngredientProperty item) => item.property,
                compareFn: _compareIngredientProperties,
                selectedItem: ingredient.category.isNotEmpty
                    ? IndexedIngredientProperty(property: ingredient.category, index: index)
                    : null,
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

  bool _compareIngredientProperties(IndexedIngredientProperty? item, IndexedIngredientProperty? selectedItem) {
    if (item == null || selectedItem == null) {
      return false;
    }
    return item.property == selectedItem.property;
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

  Widget _customIngredientDropdown(BuildContext context, IndexedIngredientProperty? selectedItem, String? notUsed) {
    if (selectedItem == null) {
      return Container();
    }

    return Text(selectedItem.property);
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

  _setIngredientName(IndexedIngredientProperty? selectedItem) {
    if (selectedItem == null) {
      return;
    }
    chosenDish!.ingredients[selectedItem.index].name = selectedItem.property;
    print(selectedItem.property);
  }

  _setIngredientCount(IndexedIngredientProperty? selectedItem) {
    if (selectedItem == null) {
      return;
    }
    chosenDish!.ingredients[selectedItem.index].count = int.parse(selectedItem.property);
    print(selectedItem.property);
  }

  _setIngredientCategory(IndexedIngredientProperty? selectedItem) {
    if (selectedItem == null) {
      return;
    }
    chosenDish!.ingredients[selectedItem.index].category = selectedItem.property;
    print(selectedItem.property);
  }
}
