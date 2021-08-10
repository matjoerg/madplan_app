import 'package:madplan_app/models/item.dart';

class Dish {
  String name;
  List<Item> items;

  Dish({required this.name, required this.items});

  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      name: map['name'],
      items: map['items'],
    );
  }
}
