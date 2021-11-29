import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/components/search_decoration.dart';
import 'package:madplan_app/constants/pixels.dart';
import 'package:madplan_app/models/models.dart';

import 'screens.dart';

class DishScreen extends StatefulWidget {
  const DishScreen({Key? key}) : super(key: key);

  @override
  _DishScreenState createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  Dish? chosenDish;

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
        searchFieldProps: TextFieldProps(decoration: SearchDecoration()),
        //dropdownSearchDecoration: InputDecoration(labelText: title),
        showClearButton: false,
        showSelectedItems: true,
        items: ["Opret ny", "Ret", "Retteret", "Ret med ret"],
        onChanged: _setDishName,
        label: title,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 150),
      child: CupertinoButton(
        child: Icon(CupertinoIcons.add_circled_solid),
        onPressed: () {
          setState(
            () {
              chosenDish?.ingredients.add(Item(name: "", category: "", count: 0));
            },
          );
        },
      ),
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
                  autofocus: true,
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
                  showSelectedItems: true,
                  showAsSuffixIcons: false,
                  searchFieldProps: TextFieldProps(decoration: SearchDecoration()),
                  //dropdownSearchDecoration: InputDecoration(labelText: "Kategori"),
                  label: "Kategori",
                  items: [
                    "Frugt og grønt",
                    "Kolonial",
                    "Frost",
                  ],
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
                //TODO: Save ingredient to database
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

  _addNewCategory() {
    Item newIngredient = Item(name: "", category: "");
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Ny kategori"),
          content: Padding(
            padding: EdgeInsets.only(top: 15),
            child: CupertinoTextField(
              autofocus: true,
              onChanged: (String? ingredientName) {
                if (ingredientName != null) {
                  newIngredient.name = ingredientName;
                }
              },
              placeholder: "Navn på kategori",
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text("Gem"),
              onPressed: () {
                //TODO: Save category to database
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

  Widget _buildIngredientDropdownRow(Item ingredient, int index) {
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
                searchFieldProps: TextFieldProps(decoration: SearchDecoration()),
                //dropdownSearchDecoration: InputDecoration(labelText: "Vare " + (index + 1).toString()),
                label: "Vare " + (index + 1).toString(),
                showClearButton: false,
                showSelectedItems: true,
                dropdownButtonBuilder: (_) => SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: [
                  "Kartofler",
                  "Broccoli",
                  "Rød peber",
                ],
                selectedItem: ingredient.name.isNotEmpty ? ingredient.name : null,
                onChanged: (selectedItem) {
                  _setIngredientName(selectedItem, index);
                },
                dropdownBuilder: _customIngredientDropdown,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Antal",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String? selectedCount) {
                    if (selectedCount == null) {
                      return;
                    }
                    chosenDish!.ingredients[index].count = double.parse(selectedCount.replaceAll(",", "."));
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showClearButton: false,
                showSelectedItems: true,
                dropdownButtonBuilder: (_) => SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: [
                  "Frugt og grønt",
                  "Kolonial",
                  "Frost",
                ],
                //dropdownSearchDecoration: InputDecoration(labelText: "Kategori"),
                label: "Kategori",
                onChanged: (selectedItem) {
                  _setIngredientCategory(selectedItem, index);
                },
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
        child: Icon(CupertinoIcons.clear_circled),
        onPressed: () {
          setState(() {
            print(index);
            chosenDish?.ingredients.removeAt(index);
          });
        });
  }

  Widget _customDishDropdown(BuildContext context, String? selectedItem) {
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

  Widget _customIngredientDropdown(BuildContext context, String? selectedItem) {
    if (selectedItem == null) {
      return Container();
    }

    return Text(selectedItem);
  }

  Widget _customNewIngredientDropdown(BuildContext context, String? selectedItem) {
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

  _setIngredientName(String? selectedItem, int index) {
    if (selectedItem == null) {
      return;
    }
    chosenDish!.ingredients[index].name = selectedItem;
    print(index.toString() + ": " + selectedItem);
  }

  _setIngredientCategory(String? selectedItem, int index) {
    if (selectedItem == null) {
      return;
    }
    chosenDish!.ingredients[index].category = selectedItem;
    print(index.toString() + ": " + selectedItem);
  }
}
