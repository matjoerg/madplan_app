import 'package:madplan_app/data/services/service_locator.dart';

class Category {
  String label;
  int sortOrder;

  Category({required this.label, required this.sortOrder});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      label: map[DatabaseService.columnCategoryLabel],
      sortOrder: map[DatabaseService.columnSortOrder],
    );
  }

  static List<Category> listFromJson(List<dynamic>? json) {
    return json == null ? [] : json.map((value) => Category.fromMap(value)).toList();
  }
}
