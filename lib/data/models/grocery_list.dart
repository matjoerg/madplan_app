import 'models.dart';

class GroceryList {
  Map<String, List<Item>> itemsByCategory;
  MealPlan? mealPlan;

  GroceryList({List<Item>? initialItems, this.mealPlan})
      : itemsByCategory = _mapItemsByCategory(initialItems);

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
      itemsByCategory.keys.contains(item.categoryLabel) ?
      itemsByCategory[item.categoryLabel]!.add(item) :
      itemsByCategory[item.categoryLabel] = <Item>[item];
    }
  }
}
