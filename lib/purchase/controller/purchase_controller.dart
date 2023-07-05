import 'package:blmercado/purchase/model/purchase.dart';
import 'package:blmercado/product/service/product_service_db.dart';
import 'package:blmercado/purchase/service/purchase_service_db.dart';
import 'package:flutter/cupertino.dart';

import '../../product/model/product.dart';
import '../../common/database/database_sqlite_service.dart';

class PurchaseController {
  Purchase purchase = Purchase();
  final TextEditingController purchaseNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final PurchaseServiceDb purchaseServiceDb =
      PurchaseServiceDb(dataBaseService: DatabaseSQLiteService.instance);
  final ProductServiceDb productServiceDb =
      ProductServiceDb(dataBaseService: DatabaseSQLiteService.instance);

  Future<void> savePurchase() async {
    purchase = Purchase(name: purchaseNameController.text);
    await purchaseServiceDb.insertPurchase(purchase);
    purchaseNameController.clear();
  }

  Future<Purchase> getLastPurchase() async {
    purchase = await purchaseServiceDb.getLastPurchase();
    return purchase;
  }

  Future<void> saveProduct() async {
    final String name = nameController.text;
    final double price = double.parse(priceController.text);
    final Product newProduct = Product(id: 0, name: name, price: price);
    final int id = await productServiceDb.insertProduct(newProduct);
    newProduct.id = id;
    purchase.addProduct(newProduct);
    nameController.clear();
    priceController.clear();
  }

  Future<void> updateProduct(Product product) async {
    final int rowsAffected = await productServiceDb.updateProduct(product);
    if (rowsAffected > 0) {
      final int index = purchase.products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        purchase.products[index] = product;
      }
    }
  }

  Future<void> deleteProduct(Product product) async {
    final int rowsAffected = await productServiceDb.deleteProduct(product.id);
    if (rowsAffected > 0) {
      purchase.removeProduct(product);
    }
  }

  Future<void> fetchProducts() async {
    final List<Product> fetchedProducts =
        await productServiceDb.getAllProducts();
    purchase.clear();
    purchase.addAllProducts(fetchedProducts);
  }

  void toggle(Product productDone) {
    productDone.done = !productDone.done;
    updateProduct(productDone);
  }

  double calculateTotal() {
    return purchase.calculateTotal();
  }

  int get totalProducts => purchase.products.length;
}
