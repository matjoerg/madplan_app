import 'package:madplan_app/utils/week_day.dart';
import 'package:collection/collection.dart';

import 'dish.dart';
import 'item.dart';
import 'meal.dart';

class MealPlan {
  final Map<String, Meal?> _meals = {
    Weekday.monday: null,
    Weekday.tuesday: null,
    Weekday.wednesday: null,
    Weekday.thursday: null,
    Weekday.friday: null,
    Weekday.saturday: null,
    Weekday.sunday: null,
  };

  MealPlan();

  setMainDish(String weekday, Dish? dish) {
    if (dish == null) {
      _meals[weekday] = null;
    } else if (_meals[weekday] == null) {
      _meals[weekday] = Meal(mainDish: dish);
    } else {
      _meals[weekday]?.mainDish = dish;
    }
  }

  setSideDish(String weekday, Dish? sideDish) {
    if (sideDish == null) {
      _meals[weekday]?.sideDish = null;
    } else {
      _meals[weekday]?.sideDish = sideDish;
    }
  }

  List<Item> getAllItems() {
    //TODO: Refactor method after updating models
    List<Meal> addedMeals = _meals.values.whereNotNull().toList();
    List<Item> allItems = addedMeals.expand((mealList) => mealList.mainDish.ingredients).toList();
    List<Item> allUniqueItems = [];
    List<String> allUniqueItemsLabels = [];
    for (Item item in allItems) {
      if (allUniqueItemsLabels.contains(item.label)) {
        allUniqueItems.where((uniqueItem) => uniqueItem.label == item.label).first.count += item.count;
      } else {
        allUniqueItems.add(item.copy());
        allUniqueItemsLabels.add(item.label);
      }
    }
    return allUniqueItems;
  }

  Meal? get monday => _meals[Weekday.monday];
  Meal? get tuesday => _meals[Weekday.tuesday];
  Meal? get wednesday => _meals[Weekday.wednesday];
  Meal? get thursday => _meals[Weekday.thursday];
  Meal? get friday => _meals[Weekday.friday];
  Meal? get saturday => _meals[Weekday.saturday];
  Meal? get sunday => _meals[Weekday.sunday];
}
