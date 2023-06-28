// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:blmercado/product/model/product.dart';

class Purchase {
  int? id;
  String? name;
  List<Product> products = [];
  bool? done = false;

  Purchase({this.id, this.name, this.done}) {
    createBasicPurchase();
  }

  Purchase.complete({this.id, this.name, this.done, required this.products}) {
    createBasicPurchase();
  }

  void createBasicPurchase() {
    name ??= DateTime.now().toString();
    done ??= false;
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
      sum += element.price!;
    }
    return sum;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'done': done == false ? 0 : 1,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      name: map['name'],
      done: map['done'] == 1 ? true : false,
    );
  }
}
