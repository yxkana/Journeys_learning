import 'package:places/models/place.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<sql.Database> databse() async {
    final dbPath = await sql.getDatabasesPath(); //create path to database
    return sql.openDatabase(path.join(dbPath, "places.db"),
        onCreate: (db, version) {
      //create database
      return db.execute(
          "CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT)");
    }, version: 2);
  }

  static Future<void> insert(
    String table,
    Map<String, Object> data,
  ) async {
    final sqlDB = await databse();
    await sqlDB.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqlDB = await DBHelper.databse();
    return sqlDB.query(table);
  }
}
