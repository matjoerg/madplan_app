import 'package:madplan_app/data/models/item.dart';
import 'package:madplan_app/data/services/service_locator.dart';

class Dish {
  String label;
  List<Item> ingredients;

  Dish({required this.label, required this.ingredients});

  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      label: map[DatabaseService.label],
      ingredients: Item.listFromJson(map[DatabaseService.items]),
    );
  }

  static List<Dish> listFromJson(List<dynamic>? json) {
    return json == null ? [] : json.map((value) => Dish.fromMap(value)).toList();
  }
}
