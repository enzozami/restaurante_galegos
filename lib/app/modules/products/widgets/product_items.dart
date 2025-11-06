import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

class ProductItems extends GetView<ProductsController> {
  final ProductModel modelProduct;
  const ProductItems({
    super.key,
    required this.modelProduct,
  });

  @override
  Widget build(BuildContext context) {
    final items = modelProduct.items;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 16.0),
            child: Text(
              modelProduct.category,
              style: GalegosUiDefaut.theme.textTheme.titleLarge,
            ),
          ),
          Card(
            elevation: 5,
            color: GalegosUiDefaut.theme.cardTheme.color,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              width: context.width,
              child: Column(
                children: [
                  ...items.map(
                    (e) => InkWell(
                      splashColor: GalegosUiDefaut.theme.splashColor,
                      borderRadius: BorderRadius.circular(8),
                      // onTap: () => _showItemDetailDialog(context, e),
                      onTap: () {
                        controller.setSelectedItem(e);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialogDefault(
                              visible: controller.quantity > 0 && controller.alreadyAdded == true,
                              plusMinus: Obx(() {
                                return GalegosPlusMinus(
                                  addCallback: controller.addProductUnit,
                                  removeCallback: controller.removeProductUnit,
                                  quantityUnit: controller.quantity,
                                );
                              }),
                              item: e,
                              onPressed: () {
                                controller.addItemsToCart();
                                Get.snackbar(
                                  'Item: ${e.name}',
                                  'Item adicionado ao carrinho',
                                  snackPosition: SnackPosition.TOP,
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Color(0xFFE2933C),
                                  colorText: Colors.black,
                                  isDismissible: true,
                                  overlayBlur: 0,
                                  overlayColor: Colors.transparent,
                                  barBlur: 0,
                                );
                                log('Item clicado: ${e.name} - ${e.price}');
                              },
                              onPressedR: () {
                                controller.removeAllProductsUnit();
                                controller.addItemsToCart();
                              },
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          ListTile(
                            textColor: Colors.black87,
                            title: Text(
                              e.name,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              e.description ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              FormatterHelper.formatCurrency(e.price),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: const Divider(height: 0.5, thickness: 1, color: Colors.black26),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
