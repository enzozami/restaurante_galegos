import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

class ProductItems extends GetView<ProductsController> {
  final ProductModel modelProduct;
  final List<ItemModel> modelItem;

  const ProductItems({
    super.key,
    required this.modelProduct,
    required this.modelItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: InkWell(
            // onTap: onTap,
            child: Container(
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              width: context.width,
              child: Column(
                children: modelItem
                    .where((element) {
                      log('CategoryID: ${element.categoryId}');
                      log('Category: ${modelProduct.category}');
                      return element.categoryId == modelProduct.category;
                    })
                    .map<ListTile>(
                      (e) => ListTile(
                        title: Text(
                          e.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(e.description ?? ''),
                        trailing: Text('${e.price}'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
