import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_products_lunchboxes_adm.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';

class AlimentosWidget extends GetView<LunchboxesController> {
  const AlimentosWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        final alimentos = controller.alimentosFiltrados;

        final selectedSize = controller.sizeSelected.value;

        return Visibility(
          visible: controller.admin == false,
          replacement: Visibility(
            visible: (selectedSize?.isNotEmpty ?? false),
            child: Material(
              color: GalegosUiDefaut.theme.primaryColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 16.0),
                    child: Text(
                      'MARMITAS',
                      style: GalegosUiDefaut.theme.textTheme.titleLarge,
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: GalegosUiDefaut.theme.cardTheme.color,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      width: context.width,
                      child: Column(
                        children: alimentos.map((alimento) {
                          final price =
                              selectedSize != '' ? alimento.pricePerSize[selectedSize] : null;
                          return Container(
                            constraints: BoxConstraints(
                              minHeight: 100,
                            ),
                            width: context.width,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 2,
                                  color: GalegosUiDefaut.theme.cardTheme.color,
                                  child: InkWell(
                                    splashColor: GalegosUiDefaut.theme.splashColor,
                                    onTap: () {
                                      controller.setFoodSelected(alimento);
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
                                              ? Text(
                                                  'Ativo',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                )
                                              : Text(
                                                  'Inativo',
                                                  style: TextStyle(
                                                    color: GalegosUiDefaut.colorScheme.error,
                                                  ),
                                                ),
                                          title: Text(
                                            alimento.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
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
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          child: Column(
            children: alimentos
                .where(
              (element) => element.dayName.contains(controller.dayNow),
            )
                .map((alimento) {
              final price = selectedSize != '' ? alimento.pricePerSize[selectedSize] : null;
              return Visibility(
                visible: (selectedSize?.isNotEmpty ?? false) && (alimento.temHoje),
                child: Material(
                  color: GalegosUiDefaut.theme.primaryColor,
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 100,
                    ),
                    width: context.width,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      width: context.width,
                      child: Column(
                        children: [
                          Card(
                            elevation: 2,
                            color: GalegosUiDefaut.theme.cardTheme.color,
                            child: InkWell(
                              splashColor: GalegosUiDefaut.theme.splashColor,
                              onTap: () {
                                controller.setFoodSelected(alimento);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialogDefault(
                                      visible: controller.quantity > 0 &&
                                          controller.alreadyAdded == true,
                                      alimento: alimento,
                                      onPressed: () {
                                        controller.addFoodShoppingCard();
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    title: Text(
                                      alimento.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
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
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
