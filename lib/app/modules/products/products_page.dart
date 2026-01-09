import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_header.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_items.dart';

import './products_controller.dart';

class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: controller.admin ? _FloatingActionButtonAdmin() : null,
        body: RefreshIndicator.noSpinner(
          onRefresh: controller.refreshProducts,
          child: SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              children: [
                ProductHeader(),
                Obx(() {
                  if (controller.items.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return ProductItems();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingActionButtonAdmin extends GetView<ProductsController> {
  const _FloatingActionButtonAdmin();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isPressed = false.obs;
    return Obx(() {
      final scale = isPressed.value ? 0.97 : 1.0;
      return GestureDetector(
        onTapDown: (_) => isPressed.value = true,
        onTapUp: (_) => isPressed.value = false,
        onTapCancel: () => isPressed.value = false,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 80),
          child: Align(
            alignment: AlignmentGeometry.directional(1, 1),
            child: FloatingActionButton.extended(
              onPressed: () {
                Get.toNamed('/admin/products');
              },
              icon: Icon(Icons.add),
              backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
              foregroundColor: theme.floatingActionButtonTheme.foregroundColor,
              label: Text('Adicionar'),
            ),
          ),
        ),
      );
    });
  }
}
