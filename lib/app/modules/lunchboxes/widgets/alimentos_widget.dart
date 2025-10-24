import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';

class AlimentosWidget extends GetView<LunchboxesController> {
  final AlimentoModel alimentoModel;
  const AlimentosWidget({
    required this.alimentoModel,
    super.key,
  });

  void _showItemDetailDialog(BuildContext context, AlimentoModel alimento) {
    controller.foodSelect(alimento);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          titlePadding: EdgeInsets.only(top: 20, left: 24, right: 20, bottom: 0),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: EdgeInsets.all(20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  alimento.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alimento.description,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return GalegosPlusMinus(
                      addCallback: controller.addFood,
                      removeCallback: controller.removeFood,
                      quantityUnit: controller.quantity,
                    );
                  }),
                ],
              ),
            ],
          ),
          actions: [
            Obx(() {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  controller.addFoodShoppingCard();
                  Get.snackbar(
                    'Item: ${alimento.name}',
                    'Item adicionado ao carrinho',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.amber,
                    colorText: Colors.black,
                  );
                },
                child: Text(
                  'Adicionar (${FormatterHelper.formatCurrency(controller.totalPrice)})',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

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
                  child: InkWell(
                    splashColor: Colors.amber,
                    onTap: () => _showItemDetailDialog(context, alimentoModel),
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
              ),
            ),
          ),
        );
      }),
    );
  }
}
