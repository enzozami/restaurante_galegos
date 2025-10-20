import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';

class AlimentosWidget extends GetView<LunchboxesController> {
  final AlimentoModel alimentoModel;
  const AlimentosWidget({
    required this.alimentoModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        final selectedSize = controller.sizeSelected.value;
        final price = selectedSize != '' ? alimentoModel.pricePerSize[selectedSize] : null;
        return Visibility(
          visible: (selectedSize?.isNotEmpty ?? false),
          child: Material(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              width: context.width,
              child: InkWell(
                splashColor: Colors.amber,
                onTap: () {
                  controller.foodSelect(alimentoModel);
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
                                alimentoModel.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Obx(() {
                              return GalegosPlusMinus(
                                addCallback: () => controller.addFood(),
                                removeCallback: () => controller.removeFood(),
                                quantityUnit: controller.quantity,
                              );
                            }),
                          ],
                        ),
                        content: Text(
                          alimentoModel.description,
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                            onPressed: () {
                              controller.addFoodShoppingCard();
                              log('Item clicado: ${alimentoModel.name} - $price');
                              Get.snackbar(
                                  'Item ${alimentoModel.name}', 'Item adicionado ao carrinho');

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text(
                        alimentoModel.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(alimentoModel.description),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (price != null)
                            Text(
                              FormatterHelper.formatCurrency(price),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
