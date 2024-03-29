import 'package:collection/src/iterable_extensions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madplan_app/blocs/database/database_bloc.dart';
import 'package:madplan_app/blocs/dish/dish_bloc.dart';
import 'package:madplan_app/blocs/item/item_bloc.dart';
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
  Dish? _chosenDish;
  List<Dish> _dishes = [];
  List<Item> _ingredients = [];
  List<Category> _categories = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, DatabaseState>(
      builder: (context, state) {
        if (state is DatabaseLoaded) {
          _dishes = state.dishes;
          _ingredients = state.items;
          _categories = state.categories;
        }

        return CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(ScreenConstants.database.title),
            ),
            SliverSafeArea(
              top: false,
              bottom: true,
              sliver: SliverPadding(
                padding: const EdgeInsets.all(Pixels.defaultMargin),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      _buildDishDropdown(),
                      const SizedBox(height: 30),
                      ..._buildIngredients(),
                      if (_chosenDish != null) _buildAddIngredientButton(),
                      const SizedBox(height: 20),
                      if (_chosenDish != null) _buildSaveDishButton(),
                      const SizedBox(height: 20),
                      _buildNewIngredientCategoryButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildDishDropdown() {
    return Material(
      color: Colors.white,
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(decoration: const SearchDecoration()),
        //dropdownSearchDecoration: InputDecoration(labelText: title),
        showClearButton: false,
        showSelectedItems: true,
        items: ["Opret ny", ..._dishes.map((e) => e.label).toList()],
        onChanged: _setDishName,
        label: "Valgt ret",
        dropdownBuilder: _customDishDropdown,
      ),
    );
  }

  List<Widget> _buildIngredients() {
    List<Widget> ingredientsList = [];
    if (_chosenDish == null) {
      return ingredientsList;
    }
    int index = 0;
    for (var ingredient in _chosenDish!.ingredients) {
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
              _chosenDish?.ingredients.add(Item(label: "", categoryLabel: "", count: 0));
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
          BlocProvider.of<DishBloc>(context).add(DishSaved(dish: _chosenDish!));
        },
      ),
    );
  }

  _buildNewIngredientDialog() {
    Item newIngredient = Item(label: "", categoryLabel: "");
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
                      newIngredient.label = ingredientName;
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
                    newIngredient.categoryLabel = selectedItem;
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
                BlocProvider.of<ItemBloc>(context).add(ItemAdded(ingredient: newIngredient));
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
    String? newCategoryLabel;
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Ny kategori"),
          content: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: CupertinoTextField(
              autofocus: true,
              onChanged: (String? categoryLabel) {
                  newCategoryLabel = categoryLabel;
              },
              placeholder: "Navn på kategori",
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("Gem"),
              onPressed: () {
                BlocProvider.of<ItemBloc>(context).add(ItemCategoryAdded(categoryName: newCategoryLabel!));
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
                items: [..._ingredients.map((e) => e.label).toList()],
                selectedItem: ingredient.label.isNotEmpty ? ingredient.label : null,
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
                  controller: TextEditingController(text: ingredient.count.toString()),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Antal",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String? selectedCount) {
                    if (selectedCount == null) {
                      return;
                    }
                    _chosenDish!.ingredients[index].count = double.parse(selectedCount.replaceAll(",", "."));
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
                items: [..._categories.map((e) => e.label).toList()],
                //dropdownSearchDecoration: InputDecoration(labelText: "Kategori"),
                label: "Kategori",
                selectedItem: ingredient.categoryLabel,
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
            _chosenDish?.ingredients.removeAt(index);
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
        _chosenDish = null;
      });
      return;
    }
    setState(() {
      _chosenDish = _getDish(selectedItem);
    });
    print(selectedItem);
  }

  _setNewDishName(String dishName) {
    _chosenDish!.label = dishName;
  }

  Dish? _getDish(String selectedItem) {
    if (selectedItem == "Opret ny") {
      return Dish(
        label: "",
        ingredients: [
          Item(label: "", categoryLabel: "", count: 0),
          Item(label: "", categoryLabel: "", count: 0),
        ],
      );
    } else {
      return _dishes.firstWhereOrNull((dish) => dish.label == selectedItem)?.copy();
    }
  }

  _setIngredientName(String? selectedItem, int index) {
    if (selectedItem == null) {
      return;
    }
    _chosenDish!.ingredients[index].label = selectedItem;
    print(index.toString() + ": " + selectedItem);
  }

  _setIngredientCategory(String? selectedItem, int index) {
    if (selectedItem == null) {
      return;
    }
    _chosenDish!.ingredients[index].categoryLabel = selectedItem;
    print(index.toString() + ": " + selectedItem);
  }
}
