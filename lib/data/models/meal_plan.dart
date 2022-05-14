import 'package:madplan_app/utils/week_day.dart';

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

  setMainDish(String weekday, String? dishName) {
    if (dishName == null) {
      _meals[weekday] = null;
    } else if (_meals[weekday] == null) {
      _meals[weekday] = Meal(mainDishName: dishName);
    } else {
      _meals[weekday]?.mainDishName = dishName;
    }
  }

  setSideDish(String weekday, String? dishName) {
    if (dishName == null) {
      _meals[weekday]?.sideDishName = null;
    } else {
      _meals[weekday]?.sideDishName = dishName;
    }
  }

  Meal? get monday => _meals[Weekday.monday];
  Meal? get tuesday => _meals[Weekday.tuesday];
  Meal? get wednesday => _meals[Weekday.wednesday];
  Meal? get thursday => _meals[Weekday.thursday];
  Meal? get friday => _meals[Weekday.friday];
  Meal? get saturday => _meals[Weekday.saturday];
  Meal? get sunday => _meals[Weekday.sunday];
}
