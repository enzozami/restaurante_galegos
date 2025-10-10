import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_items.dart';

class ProductsGroup extends GetView<ProductsController> {
  const ProductsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Obx(() {
        final products = controller.product;
        final items = controller.items;
        log(items.toString());

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            log('$product');
            // final item = items[index];

            return ProductItems(
              modelProduct: product,
              // modelItem: itemList,
              modelItem: items,
            );
          },
        );
      }),
    );
  }
}
