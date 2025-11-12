import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_products_lunchboxes_adm.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';

class AlimentosWidget extends GetView<LunchboxesController> {
  final FoodModel alimentoModel;
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
          visible: controller.admin == false,
          replacement: Visibility(
            visible: (selectedSize?.isNotEmpty ?? false),
            child: Material(
              color: GalegosUiDefaut.theme.primaryColor,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 100,
                ),
                width: context.width,
                child: Card(
                  elevation: 5,
                  color: GalegosUiDefaut.theme.primaryColor,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 100,
                    ),
                    width: context.width,
                    child: Column(
                      children: [
                        InkWell(
                          splashColor: GalegosUiDefaut.theme.splashColor,
                          onTap: () {
                            controller.setFoodSelected(alimentoModel);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertProductsLunchboxesAdm(
                                  title: 'ATENÇÃO',
                                  body: alimentoModel.temHoje
                                      ? 'Deseja desabilitar esse produto?'
                                      : 'Deseja habilitar esse produto?',
                                  onPressed: () async {
                                    controller.updateListFoods(alimentoModel.id, alimentoModel);
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
                                leading: alimentoModel.temHoje
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: Visibility(
            visible: (selectedSize?.isNotEmpty ?? false) && (alimentoModel.temHoje),
            child: Material(
              color: GalegosUiDefaut.theme.primaryColor,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 100,
                ),
                width: context.width,
                child: Card(
                  elevation: 5,
                  color: GalegosUiDefaut.theme.primaryColor,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 100,
                    ),
                    width: context.width,
                    child: Column(
                      children: [
                        InkWell(
                          splashColor: GalegosUiDefaut.theme.splashColor,
                          onTap: () {
                            controller.setFoodSelected(alimentoModel);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialogDefault(
                                  visible:
                                      controller.quantity > 0 && controller.alreadyAdded == true,
                                  alimento: alimentoModel,
                                  onPressed: () {
                                    controller.addFoodShoppingCard();
                                    Get.snackbar(
                                      'Item: ${alimentoModel.name}',
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
