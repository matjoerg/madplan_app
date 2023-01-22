part of 'service_locator.dart';

class DatabaseService {
  late Database _database;
  static const String _databaseName = "DishDatabase.db";
  static const String tableDishes = 'Dishes';
  static const String tableItems = 'Items';
  static const String tableDishesItems = 'DishesItems';
  static const String tableCategories = 'Categories';
  static const String tableDishTypes = 'DishTypes';

  static const String columnId = 'id';
  static const String columnLabel = 'label';
  static const String columnCategoryLabel = 'category_label';
  static const String columnDishTypeId = 'type_id';
  static const String columnCategoryId = 'category_id';
  static const String columnDishId = 'dish_id';
  static const String columnItemId = 'item_id';
  static const String columnCount = 'count';
  static const String columnSortOrder = 'sort_order';

  static const String items = 'items';

  DatabaseService._privateConstructor() {
    _init();
  }
  //static final DatabaseService instance = DatabaseService._privateConstructor();

  Future<void> _init() async {
    _database = await _initDatabase();
    GetIt.instance.signalReady(this);
  }

/*  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }*/

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  _onCreate(Database db, int version) async {
    await _createTableDishes(db);
    await _createTableItems(db);
    await _createTableDishesItems(db);
    await _createTableCategories(db);
    await _createTableDishTypes(db);

    await _seedDatabase(db);
  }

  _createTableDishes(Database db) async {
    await db.execute('''
    CREATE TABLE $tableDishes (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnLabel TEXT UNIQUE NOT NULL,
      $columnDishTypeId INTEGER NOT NULL,
      FOREIGN KEY ($columnDishTypeId) REFERENCES $tableDishTypes ($columnId)
    )
    ''');
  }

  _createTableItems(Database db) async {
    await db.execute('''
    CREATE TABLE $tableItems (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnLabel TEXT UNIQUE NOT NULL,
      $columnCategoryId INTEGER NOT NULL,
      FOREIGN KEY ($columnCategoryId) REFERENCES $tableCategories ($columnId)
    )
    ''');
  }

  _createTableDishesItems(Database db) async {
    await db.execute('''
    CREATE TABLE $tableDishesItems (
      $columnDishId INTEGER NOT NULL,
      $columnItemId INTEGER NOT NULL,
      $columnCount REAL NOT NULL,
      FOREIGN KEY ($columnDishId) REFERENCES $tableDishes ($columnId),
      FOREIGN KEY ($columnItemId) REFERENCES $tableItems ($columnId),
      UNIQUE($columnDishId, $columnItemId)
    )
    ''');
  }

  _createTableCategories(Database db) async {
    await db.execute('''
    CREATE TABLE $tableCategories (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnCategoryLabel TEXT UNIQUE NOT NULL,
      $columnSortOrder INTEGER
    )
    ''');
  }

  _createTableDishTypes(Database db) async {
    await db.execute('''
    CREATE TABLE $tableDishTypes (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnLabel TEXT UNIQUE NOT NULL
    )
    ''');
  }

  Future<List<Map<String, Object?>>> getDishLabels() async {
    List<Map<String, Object?>> dishes = await _database.rawQuery('''
    SELECT $columnId, $columnLabel FROM $tableDishes
    ''');
    return dishes;
  }

  Future<List<Map<String, Object?>>> getDishIngredients(int dishPrimaryKey) async {
    List<Map<String, Object?>> ingredients = await _database.rawQuery('''
    SELECT $tableItems.$columnLabel, $tableDishesItems.$columnCount, $tableCategories.$columnCategoryLabel FROM $tableItems
    INNER JOIN $tableDishesItems ON $tableDishesItems.$columnItemId = $tableItems.$columnId
    INNER JOIN $tableCategories ON $tableItems.$columnCategoryId = $tableCategories.$columnId
    WHERE $tableDishesItems.$columnDishId = ?
    ''', [dishPrimaryKey]);
    return ingredients;
  }

  Future<List<Map<String, Object?>>> getItems() async {
    List<Map<String, Object?>> items = await _database.rawQuery('''
    SELECT $tableItems.$columnLabel, $tableCategories.$columnCategoryLabel FROM $tableItems
    INNER JOIN $tableCategories ON $tableItems.$columnCategoryId = $tableCategories.$columnId
    ''');
    return items;
  }

  Future<List<Map<String, Object?>>> getCategories() async {
    List<Map<String, Object?>> categories = await _database.rawQuery('''
    SELECT $columnCategoryLabel, $columnSortOrder FROM $tableCategories
    ''');
    return categories;
  }

  Future<int> saveDish(String dishLabel) async {
    int? id;
    List<Map<String, Object?>> dishes = await _database.rawQuery('''
    SELECT $columnId FROM $tableDishes WHERE $columnLabel = ?
    ''', [dishLabel]);
    if (dishes.isNotEmpty) {
      id = dishes.first.values.first as int;
    } else {
      id = await _database.rawInsert('''
      INSERT INTO $tableDishes ($columnLabel, $columnDishTypeId) VALUES (?, ?)
      ''', [dishLabel, 1]);
    }
    return id;
  }

  Future<int> saveItem(String itemLabel, int categoryId) async {
    int? id;
    List<Map<String, Object?>> items = await _database.rawQuery('''
    SELECT $columnId FROM $tableItems WHERE $columnLabel = ?
    ''', [itemLabel]);
    if (items.isNotEmpty) {
      id = items.first.values.first as int;
      await _database.rawUpdate('''
      UPDATE $tableItems SET $columnCategoryId = ? WHERE $columnLabel = ?
      ''', [categoryId, itemLabel]);
    } else {
      id = await _database.rawInsert('''
      INSERT INTO $tableItems ($columnId, $columnLabel, $columnCategoryId) VALUES (?, ?)
      ''', [itemLabel, categoryId]);
    }
    return id;
  }

  Future<int> saveCategory(String categoryLabel, {int? sortOrder}) async {
    int? id;
    List<Map<String, Object?>> categories = await _database.rawQuery('''
    SELECT $columnId FROM $tableCategories WHERE $columnCategoryLabel = ?
    ''', [categoryLabel]);
    if (categories.isNotEmpty) {
      id = categories.first.values.first as int;
    } else {
      id = await _database.rawInsert('''
      INSERT INTO $tableCategories ($columnCategoryLabel, $columnSortOrder) VALUES (?, ?)
      ''', [categoryLabel, sortOrder]);
    }
    return id;
  }

  Future<void> saveDishItem(int dishId, int itemId, num count) async {
    await _database.execute('''
    INSERT OR IGNORE INTO $tableDishesItems ($columnDishId, $columnItemId, $columnCount) VALUES (?, ?, ?)
    ''', [dishId, itemId, count]);
  }

  Future<void> saveDishType(String dishTypeLabel) async {
    await _database.execute('''
    INSERT OR IGNORE INTO $tableDishTypes ($columnLabel) VALUES (?)
    ''', [dishTypeLabel]);
  }

  Future<void> deleteDishItems(int dishId) async {
    await _database.rawDelete('''
    DELETE FROM $tableDishesItems WHERE $columnDishId = ?
    ''', [dishId]);
  }

  isOpen() async {
    await GetIt.instance.isReady(instance: this);
  }

  // Used for testing
  _seedDatabase(Database db) async {
    List<dynamic> dishes = jsonDecode(await rootBundle.loadString('assets/seed_data/Dishes.json'));
    List<dynamic> items = jsonDecode(await rootBundle.loadString('assets/seed_data/Items.json'));
    List<dynamic> categories = jsonDecode(await rootBundle.loadString('assets/seed_data/Categories.json'));
    List<dynamic> dishesItems = jsonDecode(await rootBundle.loadString('assets/seed_data/DishesItems.json'));
    List<dynamic> dishTypes = jsonDecode(await rootBundle.loadString('assets/seed_data/DishTypes.json'));
    List<List<dynamic>> tables = [dishes, items, categories, dishesItems, dishTypes];

    String sqlDishes = "INSERT INTO $tableDishes ($columnId, $columnLabel, $columnDishTypeId) VALUES (?, ?, ?)";
    String sqlItems = "INSERT INTO $tableItems ($columnId, $columnLabel, $columnCategoryId) VALUES (?, ?, ?)";
    String sqlCategories =
        "INSERT INTO $tableCategories ($columnId, $columnCategoryLabel, $columnSortOrder) VALUES (?, ?, ?)";
    String sqlDishesItems =
        "INSERT INTO $tableDishesItems ($columnDishId, $columnItemId, $columnCount) VALUES (?, ?, ?)";
    String sqlDishTypes = "INSERT INTO $tableDishTypes ($columnId, $columnLabel) VALUES (?, ?)";
    List<String> sqls = [sqlDishes, sqlItems, sqlCategories, sqlDishesItems, sqlDishTypes];

    int sqlsIndex = 0;
    for (List<dynamic> table in tables) {
      for (Map<String, dynamic> entry in table) {
        await db.rawInsert(sqls[sqlsIndex], entry.values.toList());
      }
      sqlsIndex += 1;
    }
  }
}
