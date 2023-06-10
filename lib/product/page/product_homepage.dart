import 'package:blmercado/common/formatter/currency_br_real.dart';
import 'package:flutter/material.dart';

import '../controller/purchase_controller.dart';
import '../model/product.dart';

class PurchaseHomePage extends StatefulWidget {
  const PurchaseHomePage({super.key, required String title});

  @override
  PurchaseHomePageState createState() => PurchaseHomePageState();
}

class PurchaseHomePageState extends State<PurchaseHomePage> {
  final PurchaseController purchaseController = PurchaseController();
  final CurrencyBRReal currencyBRReal = CurrencyBRReal();
  double _totalProductsValue = 0;
  String _totalProductsValueText = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Shopping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Market Shopping'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: purchaseController.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Produto',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: purchaseController.priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      addProduct();
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: purchaseController.fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: purchaseController.totalProducts,
                      itemBuilder: (context, index) {
                        final Product product =
                            purchaseController.purchase.products[index];
                        return ListTile(
                          leading: Checkbox(
                            value: product.done,
                            onChanged: (bool? value) {
                              setState(() {
                                purchaseController.toggle(product);
                              });
                            },
                          ),
                          title: Text(
                            product.name,
                            style: TextStyle(
                              decoration: product.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            currencyBRReal.format(product.price),
                            style: TextStyle(
                              decoration: product.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                removeProduct(product);
                              }),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Total: $_totalProductsValue'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _calculateTotal();
                      });
                    },
                    child: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeProduct(Product product) {
    purchaseController.deleteProduct(product).whenComplete(() {
      _calculateTotal();
    });
  }

  void addProduct() {
    purchaseController.saveProduct().whenComplete(() {
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _totalProductsValue = purchaseController.calculateTotal();
    setState(() {
      _totalProductsValueText = currencyBRReal.format(_totalProductsValue);
    });
  }
}
