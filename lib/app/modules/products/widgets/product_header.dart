import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/filter_tag.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

class ProductHeader extends GetView<ProductsController> {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          SafeArea(child: Container()),
          Obx(() {
            final category = controller.category;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: category
                    .map(
                      (c) => FilterTag(
                        category: c,
                        onPressed: () => controller.searchItemsByFilter(c),
                        isSelected: controller.isProcessing.value == false
                            ? controller.categorySelected.value?.name == c.name
                            : false,
                      ),
                    )
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
