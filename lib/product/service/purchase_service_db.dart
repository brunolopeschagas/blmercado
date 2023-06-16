import 'package:sqflite/sqflite.dart';

import '../model/purchase.dart';
import 'database_sqlite_service.dart';

class PurchaseServiceDb {
  DatabaseSQLiteService dataBaseService;

  PurchaseServiceDb({required this.dataBaseService});

  Future<int> insertPurchase(Purchase purchase) async {
    Database? db = await dataBaseService.database;
    return await db!.insert('purchases', purchase.toMap());
  }

  Future<List<Purchase>> getAllPurchases() async {
    Database? db = await dataBaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query('purchases');
    return List.generate(maps.length, (index) => Purchase.fromMap(maps[index]));
  }

  Future<int> updatePurchase(Purchase purchase) async {
    Database? db = await dataBaseService.database;
    return await db!.update(
      'purchases',
      purchase.toMap(),
      where: 'id = ?',
      whereArgs: [purchase.id],
    );
  }

  Future<int> deletePurchase(int? id) async {
    Database? db = await dataBaseService.database;
    return await db!.delete(
      'purchases',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
