import 'package:madplan_app/data/models/item.dart';

class Dish {
  String name;
  List<Item> ingredients;

  Dish({required this.name, required this.ingredients});

  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      name: map['name'],
      ingredients: map['items'],
    );
  }

  static List<Dish> listFromJson(List<dynamic>? json) {
    return json == null ? [] : json.map((value) => Dish.fromMap(value)).toList();
  }
}
