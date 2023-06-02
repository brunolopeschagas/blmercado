import 'package:blmercado/product/model/product.dart';

class Purchase {
  List<Product> products = [];

  Purchase();
  Purchase.complete({required this.products});

  void addProduct(Product product) {
    products.add(product);
  }

  void addAllProducts(List<Product> products) {
    products.addAll(products);
  }

  double calculateTotal() {
    double sum = products.fold(0, (sum, next) => sum + next.price);
    return sum;
  }
}
