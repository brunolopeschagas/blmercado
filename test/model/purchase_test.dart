import 'package:blmercado/product/model/product.dart';
import 'package:blmercado/product/model/purchase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculate the total value of a purchase', () {
    Purchase purchase = Purchase.complete(products: simulateProducts());
    double totalExpected = 7.98;
    double totalFounded = purchase.calculateTotal();
    expect(totalExpected, totalFounded);
  });
}

List<Product> simulateProducts() {
  List<Product> products = [];
  products.add(Product(name: 'berimbal', price: 2.99));
  products.add(Product(name: 'cachimbo', price: 3.99));
  products.add(Product(name: 'Maracujá', price: 1.0));
  return products;
}
