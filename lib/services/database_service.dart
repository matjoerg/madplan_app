part of 'service_locator.dart';

class DatabaseService {
  Database? _database;
  static const String _databaseName = "DishDatabase.db";

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
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  _onCreate(Database db, int version) {}

  isOpen() async {
    GetIt.instance.isReady(instance: this).then((value) => debugPrint(_database?.isOpen.toString()));
  }
}
