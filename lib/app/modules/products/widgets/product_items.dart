import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/item.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

class ProductItems extends GetView<ProductsController> {
  final ProductModel modelProduct;
  const ProductItems({
    super.key,
    required this.modelProduct,
  });
  void _showItemDetailDialog(BuildContext context, Item item) {
    controller.setSelectedItem(item);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          titlePadding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: const EdgeInsets.all(20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.description ?? '',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return GalegosPlusMinus(
                      addCallback: controller.addProductUnit,
                      removeCallback: controller.removeProductUnit,
                      quantityUnit: controller.quantity,
                    );
                  }),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                controller.addItemsToCart();
                Get.snackbar(
                  'Item: ${item.name}',
                  'Item adicionado ao carrinho',
                  snackPosition: SnackPosition.TOP,
                  duration: Duration(milliseconds: 750),
                  backgroundColor: Colors.amber,
                  colorText: Colors.black,
                  isDismissible: true,
                  overlayBlur: 0,
                  overlayColor: Colors.transparent,
                  barBlur: 0,
                );
                log('Item clicado: ${item.name} - ${item.price}');
              },
              child: Text(
                'Adicionar',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: GalegosUiDefaut.theme.primaryColor,
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
                      splashColor: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _showItemDetailDialog(context, e),
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
