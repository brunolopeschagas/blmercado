import 'package:blmercado/product/model/product.dart';

class Purchase {
  List<Product> products = [];

  Purchase();
  Purchase.complete({required this.products});

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
