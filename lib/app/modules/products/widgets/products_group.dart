import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_items.dart';

class ProductsGroup extends GetView<ProductsController> {
  final ScrollController scrollController;
  const ProductsGroup({required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        final products = controller.products;
        final ProductModel? selectedCategory = controller.categorySelected.value;

        if (selectedCategory != null) {
          return ProductItems(modelProduct: selectedCategory);
        }

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: scrollController,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ProductItems(
                  modelProduct: products[index],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
