import 'package:sqflite/sqflite.dart';

import '../model/product.dart';
import '../../common/database/database_sqlite_service.dart';

class ProductServiceDb {
  final String _TBL_PRODUCTS = 'products';
  DatabaseSQLiteService dataBaseService;
  ProductServiceDb({required this.dataBaseService});

  Future<int> insertProduct(Product product) async {
    Database? db = await dataBaseService.database;
    return await db!.insert(_TBL_PRODUCTS, product.toMapBasic());
  }

  Future<List<Product>> getAllProducts() async {
    Database? db = await dataBaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query(_TBL_PRODUCTS);
    return List.generate(maps.length, (index) => Product.fromMap(maps[index]));
  }

  Future<int> updateProduct(Product product) async {
    Database? db = await dataBaseService.database;
    return await db!.update(
      _TBL_PRODUCTS,
      product.toMapBasic(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int? id) async {
    Database? db = await dataBaseService.database;
    return await db!.delete(
      _TBL_PRODUCTS,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
