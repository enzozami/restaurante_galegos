import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              modelProduct.category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Material(
                  color: GalegosUiDefaut.theme.primaryColor,
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 100,
                    ),
                    width: context.width,
                    child: Column(
                      children: [
                        ...items.map(
                          (e) => InkWell(
                            splashColor: Colors.amber,
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              controller.itemSelect(e);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Obx(() {
                                          return GalegosPlusMinus(
                                            addCallback: () => controller.addProductUnit(),
                                            removeCallback: () => controller.removeProductUnit(),
                                            quantityUnit: controller.quantity,
                                          );
                                        }),
                                      ],
                                    ),
                                    content: Text(
                                      '${e.description}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style:
                                            ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                                        onPressed: () {
                                          controller.addItemsShoppingCard();
                                          Get.snackbar(
                                              'Item: ${e.name}', 'Item adicionado ao carrinho');
                                          log('Item clicado: ${e.name} - ${e.price}');
                                          Get.back();
                                        },
                                        child: Text(
                                          'Adicionar',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    e.name,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(e.description ?? ''),
                                  trailing: Text(
                                    FormatterHelper.formatCurrency(e.price),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                  ), // recuo igual ao título
                                  child: const Divider(height: 0.5, thickness: 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
