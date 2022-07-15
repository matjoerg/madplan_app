import 'package:flutter/cupertino.dart';
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
      String dishLabel = dish[DatabaseService.label] as String;
      List<Map<String, Object?>> dishIngredients =
          await _databaseService.getDishIngredients(dishId);
      Map<String, dynamic> dishMap = {DatabaseService.label: dishLabel, DatabaseService.items: dishIngredients};
      dishes.add(Dish.fromMap(dishMap));
    }

    return dishes;
  }

  Future<List<Item>> getItems() async {
    List<Map<String, Object?>> itemsMap = await _databaseService.getItems();
    List<Item> items = Item.listFromJson(itemsMap);
    return items;
  }
}
