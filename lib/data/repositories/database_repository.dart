import 'package:madplan_app/data/models/models.dart';
import 'package:madplan_app/data/services/service_locator.dart';

class DatabaseRepository {
  final DatabaseService _databaseService = serviceLocator<DatabaseService>();

  Future<void> databaseIsReady() async {
    await _databaseService.isOpen();
  }

  Future<List<Dish>> getDishes() async {
    List<Map<String, Object?>> dishLabels = await _databaseService.getDishLabels();

    List<Dish> dishes = [];
    for (Map<String, Object?> dish in dishLabels) {
      int dishId = dish[DatabaseService.columnId] as int;
      String dishLabel = dish[DatabaseService.columnLabel] as String;
      List<Map<String, Object?>> dishIngredients = await _databaseService.getDishIngredients(dishId);
      Map<String, dynamic> dishMap = {DatabaseService.columnLabel: dishLabel, DatabaseService.items: dishIngredients};
      dishes.add(Dish.fromMap(dishMap));
    }

    return dishes;
  }

  Future<List<Item>> getItems() async {
    List<Map<String, Object?>> itemsMap = await _databaseService.getItems();
    List<Item> items = Item.listFromJson(itemsMap);
    return items;
  }

  Future<List<Category>> getCategories() async {
    List<Map<String, Object?>> categoriesMap = await _databaseService.getCategories();
    List<Category> categories = Category.listFromJson(categoriesMap);
    return categories;
  }

  Future<void> saveDish(Dish dish) async {
    int dishId = await _databaseService.saveDish(dish.label);
    for (Item ingredient in dish.ingredients) {
      int categoryId = await _databaseService.saveCategory(ingredient.category.label);
      int itemId = await _databaseService.saveItem(ingredient.label, categoryId);
      await _databaseService.saveDishItem(dishId, itemId, ingredient.count);
    }
  }

  Future<void> saveItem(Item item) async {
    int categoryId = await _databaseService.saveCategory(item.category.label);
    await _databaseService.saveItem(item.label, categoryId);
  }

  Future<void> saveCategory(String categoryLabel) async {
    await _databaseService.saveCategory(categoryLabel);
  }
}
