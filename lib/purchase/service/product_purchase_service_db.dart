import 'package:sqflite/sqflite.dart';

import '../../common/database/database_sqlite_service.dart';
import '../model/product_purchase.dart';

class ProductPurchaseServiceDb {
  final String _TBL_PRODUCTS_PURCHASED = 'products_purchased';
  final String _COLUMN_ID = 'id';
  final String _COLUMN_PRODUCT_ID = 'fk_product_id';
  final String _COLUMN_PURCHASE_ID = 'fk_purchase_id';
  final String _COLUMN_PRICE_UNIT = 'price_unit';
  final String _COLUMN_QUANTITIE = 'quantitie';
  DatabaseSQLiteService dataBaseService;
  ProductPurchaseServiceDb({required this.dataBaseService});

  Future<int> insertProductPurchase(ProductPurchase productPurchase) async {
    Database? db = await dataBaseService.database;
    return await db!.insert(_TBL_PRODUCTS_PURCHASED, productPurchase.toMap());
  }

  Future<List<ProductPurchase>> getAllProductPurchases() async {
    Database? db = await dataBaseService.database;
    final List<Map<String, dynamic>> maps =
        await db!.query(_TBL_PRODUCTS_PURCHASED);
    return List.generate(
        maps.length, (index) => ProductPurchase.fromMap(maps[index]));
  }

  Future<int> updateProductPurchase(ProductPurchase productPurchase) async {
    Database? db = await dataBaseService.database;
    return await db!.update(
      _TBL_PRODUCTS_PURCHASED,
      productPurchase.toMap(),
      where: 'fk_product_id = ? and fk_purchase_id = ?',
      whereArgs: [productPurchase.product.id, productPurchase.purchase.id],
    );
  }

  Future<int> deleteProductPurchase(ProductPurchase? productPurchase) async {
    Database? db = await dataBaseService.database;
    return await db!.delete(
      _TBL_PRODUCTS_PURCHASED,
      where: 'fk_product_id = ? and fk_purchase_id = ?',
      whereArgs: [productPurchase!.product.id, productPurchase.purchase.id],
    );
  }
}
