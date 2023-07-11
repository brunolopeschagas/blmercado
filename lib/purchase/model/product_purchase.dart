// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:blmercado/product/model/product.dart';
import 'package:blmercado/purchase/model/purchase.dart';

class ProductPurchase {
  Product product;
  Purchase purchase;
  double? priceUnit;
  double? quantitie;

  ProductPurchase(
      {required this.product,
      required this.purchase,
      this.priceUnit,
      this.quantitie});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fk_product_id': product.id,
      'fk_purchase_id': purchase.id,
      'price_unit': priceUnit,
      'quantitie': quantitie,
    };
  }

  factory ProductPurchase.fromMap(Map<String, dynamic> map) {
    return ProductPurchase(
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      purchase: Purchase.fromMap(map['purchase'] as Map<String, dynamic>),
      priceUnit: map['priceUnit'] != null ? map['priceUnit'] as double : null,
      quantitie: map['quantitie'] != null ? map['quantitie'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductPurchase.fromJson(String source) =>
      ProductPurchase.fromMap(json.decode(source) as Map<String, dynamic>);
}
