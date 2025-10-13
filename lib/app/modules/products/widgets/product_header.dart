import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/filter_tag.dart';

class ProductHeader extends GetView<ProductsController> {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          final products = controller.product;
          return Row(
            children: products
                .map(
                  (p) => FilterTag(
                    model: p,
                    onPressed: () => controller.searchItemsByFilter(p),
                    isSelected: controller.categorySelected.value?.category == p.category,
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}
