import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_items.dart';

class ProductsGroup extends GetView<ProductsController> {
  final ScrollController scrollController;
  const ProductsGroup({required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        final products = controller.product;

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: scrollController,
          itemCount: controller.categorySelected.value == null ? products.length : 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ProductItems(
                  modelProduct: controller.categorySelected.value ?? products[index],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
