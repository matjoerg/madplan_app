import 'package:madplan_app/data/services/service_locator.dart';

class Item {
  String label;
  double count;
  String categoryLabel;
  bool checked;

  Item({required this.label, required this.categoryLabel, this.count = 1.0, this.checked = false});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      label: map[DatabaseService.label],
      count: map[DatabaseService.count] ?? 1,
      categoryLabel: map[DatabaseService.categoryLabel],
      checked: map['checked'] ?? false,
    );
  }

  static List<Item> listFromJson(List<dynamic>? json) {
    return json == null ? [] : json.map((value) => Item.fromMap(value)).toList();
  }
}
