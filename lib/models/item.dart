class Item {
  String name;
  int count;

  Item({required this.name, this.count = 1});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'],
      count: map['count'] ?? 1,
    );
  }
}
