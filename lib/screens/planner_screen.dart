import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madplan_app/blocs/grocery_list/grocery_list_bloc.dart';
import 'package:madplan_app/components/search_decoration.dart';
import 'package:madplan_app/constants/pixels.dart';
import 'package:madplan_app/constants/week_day.dart';
import 'package:madplan_app/models/meal_plan.dart';
import 'package:madplan_app/services/service_locator.dart';

import 'screens.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  MealPlan mealPlan = MealPlan();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: TextButton(
          child: Text('Annuller'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: TextButton(
          child: Text('Opret'),
          onPressed: () {
            BlocProvider.of<GroceryListBloc>(context).add(GroceryListCreated(mealPlan: MealPlan()));
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
  }

  List<Widget> _buildWeekdayDropdowns() {
    List<Widget> weekdayDropdowns = [];
    for (var weekday in Weekday.all) {
      weekdayDropdowns.add(_buildDropdown(weekday));
      if (weekday != Weekday.sunday) {
        weekdayDropdowns.add(SizedBox(height: 10));
      }
    }
    return weekdayDropdowns;
  }

  _buildDropdown(String weekday) {
    return DropdownSearch<String>(
      mode: Mode.DIALOG,
      showSearchBox: true,
      searchFieldProps: TextFieldProps(decoration: SearchDecoration()),
      //dropdownSearchDecoration: InputDecoration(labelText: weekday, hintText: "Vælg en ret"),
      label: weekday,
      hint: "Vælg en ret",
      showClearButton: true,
      showSelectedItems: true,
      items: ["Ret", "Retteret", "Ret med ret"],
      onChanged: (selectedItem) {
        _addMainDishToMealPlan(selectedItem, weekday);
      },
    );
  }

  _addMainDishToMealPlan(dynamic selectedItem, String weekday) {
    if (selectedItem == null) {
      setState(() {
        mealPlan.setMainDish(weekday, selectedItem);
      });
      return;
    }
    print(selectedItem);
  }
}
