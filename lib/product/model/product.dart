class Product {
  int? id;
  String name;
  bool done;
  double? price;

  Product({this.id, required this.name, this.price, this.done = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'done': done == false ? 0 : 1,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      done: map['done'] == 1 ? true : false,
    );
  }

  Map<String, Object?> toMapBasic() {
    return {
      'name': name,
      'price': price,
      'done': done == false ? 0 : 1,
    };
  }
}
