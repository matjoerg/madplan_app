import 'models.dart';

class GroceryList {
  Map<String, List<Item>> itemsByCategory;
  MealPlan? mealPlan;

  GroceryList({List<Item>? initialItems, this.mealPlan}) : itemsByCategory = _mapItemsByCategory(initialItems);

  static Map<String, List<Item>> _mapItemsByCategory(List<Item>? items) {
    if (items == null) {
      return {};
    }
    List<Category> categories = items.map((e) => e.category).toList();
    Map<String, List<Item>> _itemsByCategory = {};

    categories.sort((a, b) {
      int? aSortOrder = a.sortOrder;
      int? bSortOrder = b.sortOrder;
      if (aSortOrder == null) {
        return 1;
      }
      if (bSortOrder == null) {
        return -1;
      }
      if (aSortOrder < bSortOrder) {
        return -1;
      }
      return 0;
    });

    for (Category category in categories) {
      List<Item> allItemsInCategory = items.where((item) => item.category.label == category.label).toList();
      if (allItemsInCategory.isNotEmpty) {
        _itemsByCategory.addAll({category.label: allItemsInCategory});
      }
    }

    return _itemsByCategory;
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
