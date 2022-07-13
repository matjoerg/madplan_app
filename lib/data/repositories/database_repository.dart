import 'package:flutter/cupertino.dart';
import 'package:madplan_app/data/models/models.dart';
import 'package:madplan_app/data/services/service_locator.dart';

class DatabaseRepository {
  final DatabaseService _databaseService = serviceLocator<DatabaseService>();

  Future<void> databaseIsReady() async {
    await _databaseService.isOpen();
  }

  Future<void> getDishes() async {
    List<Map<String, Object?>> dishLabels = await _databaseService.getDishLabels();
    List<Map<String, Object?>> dishIngredients = await _databaseService.getDishIngredients(1);
    debugPrint("Done");
  }
}
