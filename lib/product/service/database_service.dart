import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../product.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  static Database? _database;

  DatabaseService._();

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
        price REAL
      )
    ''');
  }

  Future<int> insertProduct(Product product) async {
    Database? db = await instance.database;
    return await db!.insert('products', product.toMapBasic());
  }

  Future<List<Product>> getAllProducts() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query('products');
    return List.generate(maps.length, (index) => Product.fromMap(maps[index]));
  }

  Future<int> updateProduct(Product product) async {
    Database? db = await instance.database;
    return await db!.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int? id) async {
    Database? db = await instance.database;
    return await db!.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
