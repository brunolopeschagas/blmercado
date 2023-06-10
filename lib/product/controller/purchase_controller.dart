import 'package:blmercado/product/model/purchase.dart';
import 'package:flutter/cupertino.dart';

import '../model/product.dart';
import '../service/database_service.dart';

class PurchaseController {
  final Purchase purchase = Purchase();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> saveProduct() async {
    final String name = nameController.text;
    final double price = double.parse(priceController.text);
    final Product newProduct = Product(id: 0, name: name, price: price);
    final int id = await DatabaseService.instance.insertProduct(newProduct);
    newProduct.id = id;
    purchase.addProduct(newProduct);
    nameController.clear();
    priceController.clear();
    print('list size = ${purchase.products.length}');
  }

  Future<void> updateProduct(Product product) async {
    final int rowsAffected =
        await DatabaseService.instance.updateProduct(product);
    if (rowsAffected > 0) {
      final int index = purchase.products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        purchase.products[index] = product;
      }
    }
  }

  Future<void> deleteProduct(Product product) async {
    final int rowsAffected =
        await DatabaseService.instance.deleteProduct(product.id);
    if (rowsAffected > 0) {
      purchase.removeProduct(product);
    }
  }

  Future<void> fetchProducts() async {
    final List<Product> fetchedProducts =
        await DatabaseService.instance.getAllProducts();
    purchase.clear();
    purchase.addAllProducts(fetchedProducts);
  }

  void toggle(Product productDone) {
    productDone.done = !productDone.done;
    updateProduct(productDone);
  }

  double calculateTotal() {
    print('list size calculate = ${purchase.products.length}');
    return purchase.calculateTotal();
  }

  int get totalProducts => purchase.products.length;
}
