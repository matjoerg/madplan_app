import 'package:madplan_app/constants/week_day.dart';

import 'meal.dart';

class MealPlan {
  Map<String, Meal?> meals = {
    Weekday.monday: null,
    Weekday.tuesday: null,
    Weekday.wednesday: null,
    Weekday.thursday: null,
    Weekday.friday: null,
    Weekday.saturday: null,
    Weekday.sunday: null,
  };

  MealPlan();

  setMainDish(String weekday, String? dishName) {
    if (dishName == null) {
      meals[weekday] = null;
    } else if (meals[weekday] == null) {
      meals[weekday] = Meal(mainDishName: dishName);
    } else {
      meals[weekday]?.mainDishName = dishName;
    }
  }

  setSideDish(String weekday, String? dishName) {
    if (dishName == null) {
      meals[weekday]?.sideDishName = null;
    } else {
      meals[weekday]?.sideDishName = dishName;
    }
  }
}
