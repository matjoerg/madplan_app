class Item {
  String name;
  double count;
  String category;
  bool checked;

  Item({required this.name, required this.category, this.count = 1.0, this.checked = false});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'],
      count: map['count'] ?? 1,
      category: map['category'],
      checked: map['checked'] ?? false,
    );
  }
}
