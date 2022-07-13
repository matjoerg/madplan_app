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
  static const String label = 'label';
  static const String dishTypeId = 'type_id';
  static const String categoryId = 'category_id';
  static const String dishId = 'dish_id';
  static const String itemId = 'item_id';
  static const String count = 'count';
  static const String sorting = 'sorting';

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
      $label TEXT UNIQUE NOT NULL,
      $dishTypeId INTEGER NOT NULL,
      FOREIGN KEY ($dishTypeId) REFERENCES $tableDishTypes ($columnId)
    )
    ''');
  }

  _createTableItems(Database db) async {
    await db.execute('''
    CREATE TABLE $tableItems (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $label TEXT UNIQUE NOT NULL,
      $categoryId INTEGER NOT NULL,
      FOREIGN KEY ($categoryId) REFERENCES $tableCategories ($columnId)
    )
    ''');
  }

  _createTableDishesItems(Database db) async {
    await db.execute('''
    CREATE TABLE $tableDishesItems (
      $dishId INTEGER NOT NULL,
      $itemId INTEGER NOT NULL,
      $count REAL NOT NULL,
      FOREIGN KEY ($dishId) REFERENCES $tableDishes ($columnId),
      FOREIGN KEY ($itemId) REFERENCES $tableItems ($columnId),
      UNIQUE($dishId, $itemId)
    )
    ''');
  }

  _createTableCategories(Database db) async {
    await db.execute('''
    CREATE TABLE $tableCategories (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $label TEXT UNIQUE NOT NULL,
      $sorting INTEGER NOT NULL
    )
    ''');
  }

  _createTableDishTypes(Database db) async {
    await db.execute('''
    CREATE TABLE $tableDishTypes (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $label TEXT UNIQUE NOT NULL
    )
    ''');
  }

  Future<List<Map<String, Object?>>> getDishLabels() async {
    List<Map<String, Object?>> dishes = await _database.rawQuery('''
    SELECT $label FROM $tableDishes
    ''');
    return dishes;
  }

  Future<List<Map<String, Object?>>> getDishIngredients(int dish) async {
    List<Map<String, Object?>> ingredients = await _database.rawQuery('''
    SELECT $tableItems.$label, $tableDishesItems.$count, $tableCategories.$label FROM $tableItems
    INNER JOIN $tableDishesItems ON $tableDishesItems.$itemId = $tableItems.$columnId
    INNER JOIN $tableCategories ON $tableItems.$categoryId = $tableCategories.$columnId
    WHERE $tableDishesItems.$dishId = ?
    ''', [dish]);
    return ingredients;
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

    String sqlDishes = "INSERT INTO $tableDishes ($columnId, $label, $dishTypeId) VALUES (?, ?, ?)";
    String sqlItems = "INSERT INTO $tableItems ($columnId, $label, $categoryId) VALUES (?, ?, ?)";
    String sqlCategories = "INSERT INTO $tableCategories ($columnId, $label, $sorting) VALUES (?, ?, ?)";
    String sqlDishesItems = "INSERT INTO $tableDishesItems ($dishId, $itemId, $count) VALUES (?, ?, ?)";
    String sqlDishTypes = "INSERT INTO $tableDishTypes ($columnId, $label) VALUES (?, ?)";
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
