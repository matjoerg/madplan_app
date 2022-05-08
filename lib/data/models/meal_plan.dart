import 'package:madplan_app/utils/week_day.dart';

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

  Meal? get monday => meals[Weekday.monday];
  Meal? get tuesday => meals[Weekday.tuesday];
  Meal? get wednesday => meals[Weekday.wednesday];
  Meal? get thursday => meals[Weekday.thursday];
  Meal? get friday => meals[Weekday.friday];
  Meal? get saturday => meals[Weekday.saturday];
  Meal? get sunday => meals[Weekday.sunday];
}
