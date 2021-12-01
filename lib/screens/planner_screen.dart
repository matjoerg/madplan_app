import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madplan_app/blocs/grocery_list/grocery_list_bloc.dart';
import 'package:madplan_app/components/search_decoration.dart';
import 'package:madplan_app/constants/pixels.dart';
import 'package:madplan_app/constants/week_day.dart';
import 'package:madplan_app/models/meal_plan.dart';

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
          },
        ),
        middle: Text(ScreenConstants.planner.title),
      ),
      child: Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Pixels.defaultMargin),
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: 50,
                ),
                _buildDropdown(Weekday.monday),
                SizedBox(height: 10),
                _buildDropdown(Weekday.tuesday),
                SizedBox(height: 10),
                _buildDropdown(Weekday.wednesday),
                SizedBox(height: 10),
                _buildDropdown(Weekday.thursday),
                SizedBox(height: 10),
                _buildDropdown(Weekday.friday),
                SizedBox(height: 10),
                _buildDropdown(Weekday.saturday),
                SizedBox(height: 10),
                _buildDropdown(Weekday.sunday),
                Container(
                  color: Colors.transparent,
                  height: 500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
