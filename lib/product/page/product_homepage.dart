import 'package:blmercado/common/formatter/currency_br_real.dart';
import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../product.dart';

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({super.key, required String title});

  @override
  ProductHomePageState createState() => ProductHomePageState();
}

class ProductHomePageState extends State<ProductHomePage> {
  final ProductController productController = ProductController();
  final CurrencyBRReal currencyBRReal = CurrencyBRReal();

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
                      controller: productController.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Produto',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: productController.priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        productController.addProduct();
                      });
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: productController.fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: productController.products.length,
                      itemBuilder: (context, index) {
                        final Product product =
                            productController.products[index];
                        return ListTile(
                          leading: Checkbox(
                            value: product.done,
                            onChanged: (bool? value) {
                              setState(() {
                                productController.toggle(product);
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
                            onPressed: () => setState(() {
                              productController.deleteProduct(product);
                            }),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
