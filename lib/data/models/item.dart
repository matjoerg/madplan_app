import 'package:madplan_app/data/services/service_locator.dart';

class Item {
  String label;
  double count;
  String categoryLabel;
  bool checked;

  Item({required this.label, required this.categoryLabel, this.count = 1.0, this.checked = false});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      label: map[DatabaseService.columnLabel],
      count: map[DatabaseService.columnCount] ?? 1,
      categoryLabel: map[DatabaseService.columnCategoryLabel],
      checked: map['checked'] ?? false,
    );
  }

  Item copy() {
    return Item(
      label: label,
      count: count,
      categoryLabel: categoryLabel,
      checked: checked,
    );
  }

  static List<Item> listFromJson(List<dynamic>? json) {
    return json == null ? [] : json.map((value) => Item.fromMap(value)).toList();
  }
}
