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
    final priceMini = alimentoModel.pricePerSize['mini'] ?? 0;
    final priceMedia = alimentoModel.pricePerSize['media'] ?? 0;
    log('$priceMini');

    return Material(
      child: Container(
        constraints: BoxConstraints(
          minHeight: 100,
        ),
        width: context.width,
        child: InkWell(
          splashColor: Colors.amber,
          onTap: () => log('Item clicado: ${alimentoModel.name} - $priceMini'),
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
                    Text(
                      FormatterHelper.formatCurrency(priceMini),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      FormatterHelper.formatCurrency(priceMedia),
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
  }
}
