import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madplan_app/blocs/database/database_bloc.dart';
import 'package:madplan_app/blocs/grocery_list/grocery_list_bloc.dart';
import 'package:madplan_app/data/models/dish.dart';
import 'package:madplan_app/presentation/components/search_decoration.dart';
import 'package:madplan_app/presentation/constants/pixels.dart';
import 'package:madplan_app/utils/week_day.dart';
import 'package:madplan_app/data/models/meal_plan.dart';
import 'package:madplan_app/data/services/service_locator.dart';
import 'package:collection/collection.dart';

import 'screens.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final MealPlan _mealPlan = MealPlan();
  List<Dish> _dishes = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, DatabaseState>(
      builder: (context, state) {
        if (state is DatabaseLoaded) {
          _dishes = state.dishes;
        }
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: TextButton(
              child: const Text('Annuller'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            trailing: TextButton(
              child: const Text('Opret'),
              onPressed: () {
                BlocProvider.of<GroceryListBloc>(context).add(GroceryListCreated(mealPlan: _mealPlan));
                Navigator.of(context).pop();
                serviceLocator<CupertinoTabController>().index = 0;
              },
            ),
            middle: Text(ScreenConstants.planner.title),
          ),
          child: Material(
            color: Colors.white,
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(Pixels.defaultMargin),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 50,
                      ),
                      ..._buildWeekdayDropdowns(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildWeekdayDropdowns() {
    List<Widget> weekdayDropdowns = [];
    for (var weekday in Weekday.all) {
      weekdayDropdowns.add(_buildDropdown(weekday));
      if (weekday != Weekday.sunday) {
        weekdayDropdowns.add(const SizedBox(height: 10));
      }
    }
    return weekdayDropdowns;
  }

  _buildDropdown(String weekday) {
    return DropdownSearch<String>(
      mode: Mode.DIALOG,
      showSearchBox: true,
      searchFieldProps: TextFieldProps(decoration: const SearchDecoration()),
      //dropdownSearchDecoration: InputDecoration(labelText: weekday, hintText: "Vælg en ret"),
      label: weekday,
      hint: "Vælg en ret",
      showClearButton: true,
      showSelectedItems: true,
      items: _dishes.map((e) => e.label).toList(),
      onChanged: (selectedItem) {
        _addMainDishToMealPlan(selectedItem, weekday);
      },
    );
  }

  _addMainDishToMealPlan(dynamic selectedItem, String weekday) {
      setState(() {
        _mealPlan.setMainDish(weekday, _dishes.firstWhereOrNull((dish) => dish.label == selectedItem));
      });
    print(selectedItem);
  }
}
