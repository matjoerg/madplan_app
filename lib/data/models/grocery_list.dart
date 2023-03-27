import 'models.dart';

class GroceryList {
  Map<String, List<Item>> itemsByCategory;
  MealPlan? mealPlan;

  GroceryList({List<Item>? initialItems, this.mealPlan}) : itemsByCategory = _mapItemsByCategory(initialItems);

  static Map<String, List<Item>> _mapItemsByCategory(List<Item>? items) {
    //TODO: Implement
    return {};
  }

  addItem(Item item) {
    addItems(<Item>[item]);
  }

  addItems(List<Item>? items) {
    if (items == null) {
      return this;
    }
    for (Item item in items) {
      itemsByCategory.keys.contains(item.category.label)
          ? itemsByCategory[item.category.label]!.add(item)
          : itemsByCategory[item.category.label] = <Item>[item];
    }
  }
}
