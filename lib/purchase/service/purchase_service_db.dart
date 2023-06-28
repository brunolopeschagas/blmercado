import 'package:sqflite/sqflite.dart';

import '../model/purchase.dart';
import '../../common/database/database_sqlite_service.dart';

class PurchaseServiceDb {
  final String _TBL_PURCHASES = 'purchases';
  DatabaseSQLiteService dataBaseService;
  PurchaseServiceDb({required this.dataBaseService});

  Future<int> insertPurchase(Purchase purchase) async {
    Database? db = await dataBaseService.database;
    return await db!.insert(_TBL_PURCHASES, purchase.toMap());
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
