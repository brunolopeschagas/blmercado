import 'package:sqflite/sqflite.dart';

import '../model/product.dart';
import 'database_service.dart';

class ProductServiceDb {
  DatabaseService dataBaseService;

  ProductServiceDb({required this.dataBaseService});

  Future<int> insertProduct(Product product) async {
    Database? db = await dataBaseService.database;
    return await db!.insert('products', product.toMapBasic());
  }

  Future<List<Product>> getAllProducts() async {
    Database? db = await dataBaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query('products');
    return List.generate(maps.length, (index) => Product.fromMap(maps[index]));
  }

  Future<int> updateProduct(Product product) async {
    Database? db = await dataBaseService.database;
    return await db!.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int? id) async {
    Database? db = await dataBaseService.database;
    return await db!.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
