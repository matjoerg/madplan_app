class Item {
  String name;
  double count;
  String category;

  Item({required this.name, required this.category, this.count = 1.0});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'],
      count: map['count'] ?? 1,
      category: map['category'],
    );
  }
}
