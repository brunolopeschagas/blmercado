import 'package:blmercado/product/model/product.dart';

class Purchase {
  String? name;
  List<Product> products = [];

  Purchase() {
    createNameAuto();
  }

  Purchase.complete({required this.products}) {
    createNameAuto();
  }

  void createNameAuto() {
    name ??= DateTime.now().toString();
  }

  void addProduct(Product productToAdd) {
    products.add(productToAdd);
  }

  void clear() {
    products.clear();
  }

  void addAllProducts(List<Product> productsToAdd) {
    products.addAll(productsToAdd);
  }

  void removeProduct(Product productToRemove) {
    products.remove(productToRemove);
  }

  double calculateTotal() {
    double sum = 0;
    for (Product element in products) {
      sum += element.price;
    }
    return sum;
  }
}
