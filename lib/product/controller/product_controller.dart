import 'package:flutter/cupertino.dart';

import '../product.dart';
import '../service/database_service.dart';

class ProductController {
  final List<Product> products = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> addProduct() async {
    final String name = nameController.text;
    final double price = double.parse(priceController.text);
    final Product newProduct = Product(id: 0, name: name, price: price);
    final int id = await DatabaseService.instance.insertProduct(newProduct);
    newProduct.id = id;
    products.add(newProduct);
    nameController.clear();
    priceController.clear();
  }

  Future<void> updateProduct(Product product) async {
    final int rowsAffected =
        await DatabaseService.instance.updateProduct(product);
    if (rowsAffected > 0) {
      final int index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
      }
    }
  }

  Future<void> deleteProduct(Product product) async {
    final int rowsAffected =
        await DatabaseService.instance.deleteProduct(product.id);
    if (rowsAffected > 0) {
      products.remove(product);
    }
  }

  Future<void> fetchProducts() async {
    final List<Product> fetchedProducts =
        await DatabaseService.instance.getAllProducts();
    products.clear();
    products.addAll(fetchedProducts);
  }

  void toggle(Product productDone) {
    productDone.done = !productDone.done;
    updateProduct(productDone);
  }
}
