import 'models.dart';

class GroceryList {
  Map<String, List<Item>> items;
  MealPlan? mealPlan;

  GroceryList({required this.items, this.mealPlan});

  factory GroceryList.empty() {
    return GroceryList(items: Map());
  }
}
