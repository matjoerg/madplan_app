import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madplan_app/presentation/components/search_decoration.dart';
import 'package:madplan_app/presentation/constants/pixels.dart';
import 'package:madplan_app/data/models/models.dart';

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
        SliverSafeArea(
          top: false,
          bottom: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.all(Pixels.defaultMargin),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  _buildDishDropdown("Valgt ret"),
                  const SizedBox(height: 30),
                  ..._buildIngredients(),
                  if (chosenDish != null) _buildAddIngredientButton(),
                  const SizedBox(height: 20),
                  if (chosenDish != null) _buildSaveDishButton(),
                  const SizedBox(height: 20),
                  _buildNewIngredientCategoryButtons(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildDishDropdown(String title) {
    return Material(
      color: Colors.white,
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(decoration: const SearchDecoration()),
        //dropdownSearchDecoration: InputDecoration(labelText: title),
        showClearButton: false,
        showSelectedItems: true,
        items: const ["Opret ny", "Ret", "Retteret", "Ret med ret"],
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
    for (var ingredient in chosenDish!.ingredients) {
      ingredientsList.add(_buildIngredientDropdownRow(ingredient, index));
      index++;
    }
    return ingredientsList;
  }

  Widget _buildAddIngredientButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150),
      child: CupertinoButton(
        child: const Icon(CupertinoIcons.add_circled_solid),
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
        const Spacer(),
        TextButton(
          child: const Text("Ny vare"),
          onPressed: _buildNewIngredientDialog,
        ),
        TextButton(
          child: const Text("Ny kategori"),
          onPressed: _addNewCategory,
        ),
      ],
    );
  }

  Widget _buildSaveDishButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: CupertinoButton.filled(
        child: const Text("Gem ret"),
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
          title: const Text("Ny vare"),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
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
                color: Colors.white,
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showClearButton: false,
                  showSelectedItems: true,
                  showAsSuffixIcons: false,
                  searchFieldProps: TextFieldProps(decoration: const SearchDecoration()),
                  //dropdownSearchDecoration: InputDecoration(labelText: "Kategori"),
                  label: "Kategori",
                  items: const [
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
              child: const Text("Gem"),
              onPressed: () {
                //TODO: Save ingredient to database
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
                child: const Text("Annuller"),
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
          title: const Text("Ny kategori"),
          content: Padding(
            padding: const EdgeInsets.only(top: 15),
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
              child: const Text("Gem"),
              onPressed: () {
                //TODO: Save category to database
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
                child: const Text("Annuller"),
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(decoration: const SearchDecoration()),
                //dropdownSearchDecoration: InputDecoration(labelText: "Vare " + (index + 1).toString()),
                label: "Vare " + (index + 1).toString(),
                showClearButton: false,
                showSelectedItems: true,
                dropdownButtonBuilder: (_) => const SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: const [
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Antal",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                dropdownButtonBuilder: (_) => const SizedBox(width: 8),
                showAsSuffixIcons: false,
                items: const [
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
        child: const Icon(CupertinoIcons.clear_circled),
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
      return const Text(
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