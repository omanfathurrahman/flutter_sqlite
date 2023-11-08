import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/saham.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE saham ( tickerid INTEGER PRIMARY KEY AUTOINCREMENT, ticker TEXT NOT NULL, open INTEGER NOT NULL, high INTEGER NOT NULL, last INTEGER NOT NULL, change TEXT )",
        );
      },
      version: 1,
    );
  }

  Future<int> insertSaham(List<Saham> sahams) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var itemSaham in sahams) {
      result = await db.insert('saham', itemSaham.toMap());
    }
    return result;
  }

  Future<List<Saham>> retrieveSaham() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('saham');
    return queryResult.map((e) => Saham.fromMap(e)).toList();
  }

  Future<int> updateSaham(Saham saham) async {
    final Database db = await initializeDB();
    return await db.update(
      'saham',
      saham.toMap(),
      where: 'tickerid = ?',
      whereArgs: [saham.tickerid],
    );
  }
}
