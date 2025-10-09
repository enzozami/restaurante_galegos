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
      child: ListView.builder(
        // itemCount: ,
        itemBuilder: (context, index) {
          return Obx(() {
            final products = controller.product;
            final items = controller.items;
            return Column(
              children: products.map((p) {
                final itensProduto = items.where((i) => i.id == p.id).toList();
                return ProductItems(modelItem: itensProduto, modelProduct: p);
              }).toList(),
            );
          });
        },
      ),
    );
  }
}
