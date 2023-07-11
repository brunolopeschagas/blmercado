import 'package:blmercado/common/formatter/currency_br_real.dart';
import 'package:blmercado/purchase/model/purchase.dart';
import 'package:flutter/material.dart';

import '../controller/purchase_controller.dart';
import '../../product/model/product.dart';

class PurchaseHomePage extends StatefulWidget {
  const PurchaseHomePage({super.key, required String title});

  @override
  PurchaseHomePageState createState() => PurchaseHomePageState();
}

class PurchaseHomePageState extends State<PurchaseHomePage> {
  final PurchaseController purchaseController = PurchaseController();
  final CurrencyBRReal currencyBRReal = CurrencyBRReal();
  String _totalProductsValueText = '';
  int _totalItens = 0;
  int _selectedIndex = 0;
  late Future<List<Product>> productsPurchased;
  late Future<Purchase> lastPurchase;

  @override
  void initState() {
    super.initState();
    lastPurchase = purchaseController.getLastPurchase();
    productsPurchased = purchaseController.fetchProducts();
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<Purchase>(
                      future: lastPurchase,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text('${snapshot.data!.name}');
                        }
                        return const Text('No data available yet...');
                      })
                ],
              ),
            ),
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
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: productsPurchased,
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
                            currencyBRReal.format(product.price!),
                            style: TextStyle(
                              decoration: product.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _removeProduct(product);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total: $_totalProductsValueText'),
                  const SizedBox(width: 20),
                  Text('$_totalItens Itens'),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addProduct();
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Minhas compras',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Nova Compra',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (int index) {
            switch (index) {
              case 0:
                // only scroll to top when current index is selected.
                if (_selectedIndex == index) {}
              case 1:
                _displayPurchaseDialog(context);
            }
            setState(
              () {
                _selectedIndex = index;
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _displayPurchaseDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Nome para a compra:'),
            content: TextField(
              autofocus: true,
              controller: purchaseController.purchaseNameController,
              decoration: const InputDecoration(
                  hintText: "Ex: Compra de agosto no Mercadinho"),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: const Text('Desisti'),
                    onPressed: () {
                      setState(() {
                        purchaseController.purchaseNameController.clear();
                        Navigator.pop(context);
                      });
                    },
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _savePurchase,
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void _savePurchase() {
    purchaseController.savePurchase().whenComplete(() {
      Navigator.pop(context);
      setState(() {
        lastPurchase = purchaseController.getLastPurchase();
      });
    });
  }

  void _removeProduct(Product product) {
    purchaseController.deleteProduct(product).whenComplete(() {
      _calculateTotal();
    });
  }

  void _addProduct() {
    purchaseController.saveProduct().whenComplete(() async {
      purchaseController.addProdutPurchased(
          purchaseController.purchase.products.last, await lastPurchase);
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    double totalProductsValue = purchaseController.calculateTotal();
    setState(() {
      _totalProductsValueText = currencyBRReal.format(totalProductsValue);
      _totalItens = purchaseController.totalProducts;
    });
  }
}
