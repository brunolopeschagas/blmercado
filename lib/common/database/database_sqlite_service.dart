import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseSQLiteService {
  static final DatabaseSQLiteService instance = DatabaseSQLiteService._();
  static Database? _database;

  DatabaseSQLiteService._();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'market.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY,
        name TEXT,
        price REAL,
        done INTEGER
      );
      CREATE TABLE purchases(
        id INTEGER PRIMARY KEY,
        name TEXT,
        done INTEGER
      );
      CREATE TABLE products_purchased(
        fk_product_id INTEGER,
        fk_purchase_id INTEGER,
        price_unit REAL,
        quantitie REAL
      );
    ''');
  }

  Future close() async => _database!.close();
}
