import 'models.dart';

class GroceryList {
  Map<String, List<Item>> itemsByCategory;
  MealPlan? mealPlan;

  GroceryList({required this.itemsByCategory, this.mealPlan});

  factory GroceryList.empty() {
    return GroceryList(itemsByCategory: {});
  }
}
