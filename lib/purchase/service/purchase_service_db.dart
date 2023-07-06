import 'package:sqflite/sqflite.dart';

import '../model/purchase.dart';
import '../../common/database/database_sqlite_service.dart';

class PurchaseServiceDb {
  final String _TBL_PURCHASES = 'purchases';
  final String _COLUMN_ID = 'id';
  final String _COLUMN_NAME = 'name';
  final String _COLUMN_DONE = 'done';
  DatabaseSQLiteService dataBaseService;
  PurchaseServiceDb({required this.dataBaseService});

  Future<int> insertPurchase(Purchase purchase) async {
    Database? db = await dataBaseService.database;
    return await db!.insert(_TBL_PURCHASES, purchase.toMap());
  }

  Future<Purchase> getLastPurchase() async {
    Database? db = await dataBaseService.database;
    List<Map<String, dynamic>> maps = await db!.query(_TBL_PURCHASES,
        columns: [_COLUMN_ID, _COLUMN_NAME, _COLUMN_NAME, _COLUMN_DONE],
        orderBy: '$_COLUMN_ID DESC',
        limit: 1);

    return Purchase.fromMap(maps.first);
  }

  Future<List<Purchase>> getAllPurchases() async {
    Database? db = await dataBaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query(_TBL_PURCHASES);
    return List.generate(maps.length, (index) => Purchase.fromMap(maps[index]));
  }

  Future<int> updatePurchase(Purchase purchase) async {
    Database? db = await dataBaseService.database;
    return await db!.update(
      _TBL_PURCHASES,
      purchase.toMap(),
      where: 'id = ?',
      whereArgs: [purchase.id],
    );
  }

  Future<int> deletePurchase(int? id) async {
    Database? db = await dataBaseService.database;
    return await db!.delete(
      _TBL_PURCHASES,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
