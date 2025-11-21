import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_products_lunchboxes_adm.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_items.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';

class AlimentosWidget extends GetView<LunchboxesController> {
  const AlimentosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        final alimentos = controller.alimentosFiltrados;
        final selectedSize = controller.sizeSelected.value;

        return Visibility(
          visible: controller.admin == false,
          replacement: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 16.0),
                child: Text('MARMITAS', style: GalegosUiDefaut.theme.textTheme.titleLarge),
              ),
              Card(
                elevation: 5,
                color: GalegosUiDefaut.theme.cardTheme.color,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  constraints: BoxConstraints(minHeight: 100),
                  width: context.width,
                  child: Column(
                    children: alimentos.map((alimento) {
                      final price = selectedSize != '' ? alimento.pricePerSize[selectedSize] : null;
                      return Container(
                        constraints: BoxConstraints(minHeight: 100),
                        width: context.width,
                        child: Column(
                          children: [
                            Card(
                              elevation: 2,
                              color: GalegosUiDefaut.theme.cardTheme.color,
                              child: InkWell(
                                splashColor: GalegosUiDefaut.theme.splashColor,
                                onTap: () {
                                  controller.setFoodSelected(alimento, selectedSize ?? '');
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertProductsLunchboxesAdm(
                                        title: 'ATENÇÃO',
                                        body: alimento.temHoje
                                            ? 'Deseja desabilitar esse produto?'
                                            : 'Deseja habilitar esse produto?',
                                        onPressed: () async {
                                          controller.updateListFoods(alimento.id, alimento);
                                          Get.back();
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      leading: alimento.temHoje
                                          ? Text('Ativo', style: TextStyle(color: Colors.green))
                                          : Text(
                                              'Inativo',
                                              style: TextStyle(
                                                color: GalegosUiDefaut.colorScheme.error,
                                              ),
                                            ),
                                      title: Text(
                                        alimento.name,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      subtitle: Text(alimento.description),
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
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
          child: SizedBox(
            // constraints: const BoxConstraints(minHeight: 100),
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: alimentos
                  .where(
                    (element) => element.dayName.contains(controller.dayNow) && element.temHoje,
                  )
                  .map((alimento) {
                    return CardItems(
                      width: context.widthTransformer(reducedBy: 10),
                      height: 280,
                      isProduct: false,
                      imageHeight: alimento.description.isEmpty ? 150 : 130,
                      titulo: alimento.name,
                      image: alimento.image,
                      descricao: alimento.description,
                      onPressed: () {},
                      onTap: () {},
                      styleTitle: GalegosUiDefaut.theme.textTheme.titleMedium,
                      styleDescricao: GalegosUiDefaut.theme.textTheme.bodyLarge,
                      stylePreco: GalegosUiDefaut.textLunchboxes.titleMedium,
                      precoMini: FormatterHelper.formatCurrency(alimento.pricePerSize['mini'] ?? 0),
                      precoMedia: FormatterHelper.formatCurrency(
                        alimento.pricePerSize['media'] ?? 0,
                      ),
                      elevatedButton: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: controller.availableSizes
                            .map(
                              (s) => ElevatedButton(
                                style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
                                onPressed: () {
                                  log('alimentosWidget - $s');
                                  controller.setFoodSelected(alimento, s);
                                  controller.filterPrice(s);
                                  controller.sizeSelected.value = s;
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialogDefault(
                                        visible: controller.quantity > 0,
                                        alimento: alimento,
                                        onPressed: () {
                                          controller.addFoodShoppingCard();
                                          log(
                                            'Item: ${alimento.name} - Valor: ${alimento.pricePerSize[s]}',
                                          );
                                          Get.snackbar(
                                            'Item: ${alimento.name}',
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
                                        },
                                        onPressedR: () {
                                          controller.removeAllFoodsUnit();
                                          controller.addFoodShoppingCard();
                                        },
                                        plusMinus: Obx(() {
                                          return GalegosPlusMinus(
                                            addCallback: controller.addFood,
                                            removeCallback: controller.removeFood,
                                            quantityUnit: controller.quantity,
                                          );
                                        }),
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      s[0].toUpperCase() + s.substring(1),
                                      style: GalegosUiDefaut.textLunchboxes.titleSmall,
                                    ),
                                    Text(
                                      FormatterHelper.formatCurrency(alimento.pricePerSize[s] ?? 0),
                                      style: GalegosUiDefaut.textLunchboxes.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        );
      }),
    );
  }
}
