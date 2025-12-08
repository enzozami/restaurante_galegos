import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_for_add_to_cart.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_header.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_items.dart';
import './products_controller.dart';

class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: controller.admin ? _FloatingActionButtonAdmin() : null,
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
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
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

class _FloatingActionButtonAdmin extends StatefulWidget {
  const _FloatingActionButtonAdmin();

  @override
  State<_FloatingActionButtonAdmin> createState() => _FloatingActionButtonAdminState();
}

class _FloatingActionButtonAdminState
    extends GalegosState<_FloatingActionButtonAdmin, ProductsController> {
  @override
  Widget build(BuildContext context) {
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
      backgroundColor: GalegosUiDefaut.theme.floatingActionButtonTheme.backgroundColor,
      foregroundColor: GalegosUiDefaut.theme.floatingActionButtonTheme.foregroundColor,
      label: Text('Adicionar'),
    );
  }
}
