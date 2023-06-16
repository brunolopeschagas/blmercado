import 'package:blmercado/product/model/product.dart';
import 'package:blmercado/product/model/purchase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shold create a named purchase', () {
    Purchase purchase = Purchase(name: 'Compra do barzinho da esquina');
    String expectedName = 'Compra do barzinho da esquina';
    expect(purchase.name, expectedName);
  });

  test('calculate the total value of a purchase', () {
    Purchase purchase = Purchase.complete(products: simulateProducts());
    double totalExpected = 461.38;
    double totalFounded = purchase.calculateTotal();
    expect(totalExpected, totalFounded);
  });

  test('should create the name of the purchase automatic', () {
    Purchase purchase = Purchase();
    expect(purchase.name?.isNotEmpty, true);
  });
}

List<Product> simulateProducts() {
  List<Product> products = [];
  products.add(Product(name: 'berimbal', price: 1.99));
  products.add(Product(name: 'Sabão', price: 19.90));
  products.add(Product(name: 'cachimbo', price: 36));
  products.add(Product(name: 'Pneu', price: 399.99));
  products.add(Product(name: 'Maracujá', price: 2.50));
  products.add(Product(name: 'Pera', price: 1));
  return products;
}
