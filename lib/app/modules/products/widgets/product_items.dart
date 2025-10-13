import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

class ProductItems extends GetView<ProductsController> {
  final ProductModel modelProduct;
  const ProductItems({
    super.key,
    required this.modelProduct,
  });

  @override
  Widget build(BuildContext context) {
    final items = modelProduct.items;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              modelProduct.category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Material(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 100,
                    ),
                    width: context.width,
                    child: Column(
                      children: [
                        ...items.map(
                          (e) => InkWell(
                            splashColor: Colors.amber,
                            onTap: () {
                              log('Item clicado: ${e.name} - ${e.price}');
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    e.name,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(e.description ?? ''),
                                  trailing: Text(
                                    FormatterHelper.formatCurrency(e.price),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
