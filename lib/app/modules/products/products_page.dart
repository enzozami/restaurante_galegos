import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/dialogs/alert_for_add_to_cart.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_header.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_items.dart';

import './products_controller.dart';

class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: controller.admin
          ? _FloatingActionButtonAdmin()
          : null,
      body: RefreshIndicator(
        onRefresh: controller.refreshProducts,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              ProductHeader(),
              const SizedBox(height: 20),
              controller.admin
                  ? SizedBox.shrink()
                  : Center(
                      child: Text(
                        'Selecione algum item para adicionar ao carrinho*',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 11,
                        ),
                      ),
                    ),
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
    );
  }
}

class _FloatingActionButtonAdmin extends GetView<ProductsController> {
  const _FloatingActionButtonAdmin();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Form(
              key: controller.formKey,
              child: AlertForAddToCart(
                isProduct: true,
              ),
            );
          },
        );
      },
      icon: Icon(Icons.add),
      backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
      foregroundColor: theme.floatingActionButtonTheme.foregroundColor,
      label: Text('Adicionar'),
    );
  }
}
