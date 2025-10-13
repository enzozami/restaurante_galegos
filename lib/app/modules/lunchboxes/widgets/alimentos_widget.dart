import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final alimento = controller.alimentos;
    return Column(
      children: [
        Material(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 100,
            ),
            width: context.width,
            child: Column(
              children: [
                ...alimento.map(
                  (a) => InkWell(
                    splashColor: Colors.amber,
                    onTap: () => log('Item clicado: ${a.name}'),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            a.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(a.description),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
