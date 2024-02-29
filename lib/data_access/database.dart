import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDB {
  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDB();
    }
    return _db!;
  }

  Future<Database> initDB() async {
    String databasePath = await getDatabasesPath();
    String myPath = join(databasePath, 'contacts');
    Database mydb = await openDatabase(myPath, onCreate: _onCreate, version: 1);
    return mydb;
  }

  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute(''' 
    create table countries (
      ID integer primary key autoincrement,
      CountryName text not null,
      Code integer not null,
      PhoneCode text not null
    )
    ''');

    batch.execute('''create table contacts (
      ID integer primary key autoincrement,
      Name text not null,
      Email text,
      Phone text not null,
      Address text not null,
      DateOfBirth text not null,
      CountryID integer not null,
       foreign key (CountryID) references countries(ID)
    )''');
    await batch.commit();

    print('_onCreate =============================');
  }

  Future<List<Map<String, dynamic>>> readData(String sql,
      [List<String?>? args]) async {
    Database mydb = await db;
    return await mydb.rawQuery(sql, args);
  }

  Future<int> insert(String sql, [List<String?>? args]) async {
    Database mydb = await db;
    return await mydb.rawInsert(sql, args);
  }

  Future<int> update(String sql, [List<String?>? args]) async {
    Database mydb = await db;
    return await mydb.rawUpdate(sql, args);
  }

  Future<int> delete(String sql, [List<String?>? args]) async {
    Database mydb = await db;
    return await mydb.rawDelete(sql, args);
  }

  Future<void> eraseDataBase() async {
    String databasePath = await getDatabasesPath();
    String myPath = join(databasePath, 'contacts');

    await deleteDatabase(myPath);
  }
}
