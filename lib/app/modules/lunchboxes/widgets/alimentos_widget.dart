import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(() {
        final selectedSize = controller.sizeSelected.value;
        final price = selectedSize != '' ? alimentoModel.pricePerSize[selectedSize] : null;
        return Material(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 100,
            ),
            width: context.width,
            child: InkWell(
              splashColor: Colors.amber,
              onTap: () => log('Item clicado: ${alimentoModel.name} - $price'),
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
