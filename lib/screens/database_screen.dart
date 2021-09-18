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
          padding: EdgeInsets.only(
            top: Pixels.defaultMargin,
            left: Pixels.defaultMargin,
            right: Pixels.defaultMargin,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              _buildIngredients(),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: Pixels.defaultMargin),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                if (chosenDish != null) _buildAddIngredientButton(),
                SizedBox(height: 20),
                if (chosenDish != null) _buildSaveDishButton(),
                SizedBox(height: 20),
                _buildNewIngredientCategoryButtons(),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([]),
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

  Widget _buildAddIngredientButton() {
    return CupertinoButton(
      child: Icon(CupertinoIcons.add_circled_solid),
      onPressed: () {
        setState(
          () {
            chosenDish?.ingredients.add(Item(name: "", category: "", count: 0));
          },
        );
      },
    );
  }

  Widget _buildNewIngredientCategoryButtons() {
    return Row(
      children: [
        Spacer(),
        TextButton(
          child: Text("Ny vare"),
          onPressed: _buildNewIngredientDialog,
        ),
        TextButton(
          child: Text("Ny kategori"),
          onPressed: _addNewCategory,
        ),
      ],
    );
  }

  Widget _buildSaveDishButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: CupertinoButton.filled(
        child: Text("Gem ret"),
        onPressed: () {
          //TODO: Save dish
        },
      ),
    );
  }

  _buildNewIngredientDialog() {
    Item newIngredient = Item(name: "", category: "");
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Ny vare"),
          content: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: CupertinoTextField(
                  onChanged: (String? ingredientName) {
                    if (ingredientName != null) {
                      newIngredient.name = ingredientName;
                    }
                  },
                  placeholder: "Navn på vare",
                ),
              ),
              Material(
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showClearButton: false,
                  showSelectedItem: true,
                  showAsSuffixIcons: false,
                  items: [
                    "Frugt og grønt",
                    "Kolonial",
                    "Frost",
                  ],
                  label: "Kategori",
                  onChanged: (String? selectedItem) {
                    if (selectedItem == null) {
                      return;
                    }
                    newIngredient.category = selectedItem;
                  },
                  dropdownBuilder: _customNewIngredientDropdown,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text("Gem"),
              onPressed: () {
                // TODO: Save ingredient to database
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
                child: Text("Annuller"),
                onPressed: () {
                  Navigator.pop(context);
                },
                isDestructiveAction: true),
          ],
        );
      },
    );
  }

  _addNewCategory() {}

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
        child: Icon(CupertinoIcons.clear_circled),
        onPressed: () {
          setState(() {
            print(index);
            chosenDish?.ingredients.removeAt(index);
          });
        });
  }

  Widget _customDishDropdown(BuildContext context, String? selectedItem, String? notUsed) {
    if (selectedItem == "Opret ny") {
      return CupertinoTextField(
        placeholder: "Navn på ny ret",
        onChanged: _setNewDishName,
      );
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

  Widget _customNewIngredientDropdown(BuildContext context, String? selectedItem, String? notUsed) {
    if (selectedItem == null) {
      return Container();
    }

    return Text(selectedItem);
  }

  _setDishName(dynamic selectedItem) {
    if (selectedItem == null) {
      setState(() {
        chosenDish = null;
      });
      return;
    }
    setState(() {
      chosenDish = _getDish(selectedItem);
    });
    print(selectedItem);
  }

  _setNewDishName(String dishName) {
    chosenDish!.name = dishName;
  }

  Dish _getDish(String selectedItem) {
    //TODO: Get dish from database
    if (selectedItem == "Opret ny") {
      return Dish(
        name: "",
        ingredients: [
          Item(name: "", category: "", count: 0),
          Item(name: "", category: "", count: 0),
        ],
      );
    } else {
      return Dish(
        name: selectedItem,
        ingredients: [
          Item(name: "Kartofler", category: "Frugt og grønt"),
          Item(name: "Mel", category: "Kolonial"),
        ],
      );
    }
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
