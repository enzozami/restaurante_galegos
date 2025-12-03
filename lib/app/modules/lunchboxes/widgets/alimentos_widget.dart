import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_products_lunchboxes_adm.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_items.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';

import '../../../core/ui/widgets/card_shimmer.dart';

class AlimentosWidget extends GetView<LunchboxesController> {
  const AlimentosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        final alimentos = controller.alimentosFiltrados;
        final selectedSize = controller.sizeSelected.value;

        return controller.admin
            ? _FoodsAdmin(alimentos: alimentos, selectedSize: selectedSize ?? '')
            : _FoodClient(alimentos: alimentos, controller: controller);
      }),
    );
  }
}

class _FoodClient extends StatelessWidget {
  const _FoodClient({required this.alimentos, required this.controller});

  final List<FoodModel> alimentos;
  final LunchboxesController controller;

  @override
  Widget build(BuildContext context) {
    // controller.loading.value = true;
    return SizedBox(
      width: double.infinity,
      child: controller.loading.value
          ? Wrap(
              children: List.generate(
                3,
                (_) => CardShimmer(
                  height: 280,
                  width: context.widthTransformer(reducedBy: 10),
                ).paddingOnly(bottom: 10),
              ),
            )
          : Wrap(
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
    );
  }
}

class _FoodsAdmin extends StatefulWidget {
  final List<FoodModel> alimentos;
  final String selectedSize;

  const _FoodsAdmin({required this.alimentos, required this.selectedSize});

  @override
  State<_FoodsAdmin> createState() => _FoodsAdminState();
}

class _FoodsAdminState extends GalegosState<_FoodsAdmin, LunchboxesController> {
  final _formKey = GlobalKey<FormState>();

  final controllerCard = MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        ...widget.alimentos.map((alimento) {
          return Container(
            constraints: BoxConstraints(minHeight: 100),
            width: context.width,
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  color: GalegosUiDefaut.theme.cardTheme.color,
                  child: Dismissible(
                    background: Container(
                      color: GalegosUiDefaut.colorScheme.error,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(15),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    key: ValueKey(alimento.id),
                    confirmDismiss: (_) async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: GalegosUiDefaut.colors['fundo'],
                            titlePadding: EdgeInsets.only(top: 25, bottom: 0),
                            contentPadding: EdgeInsets.only(top: 15, bottom: 0),
                            actionsPadding: EdgeInsets.symmetric(vertical: 15),
                            title: Text(
                              'ATENÇÃO',
                              textAlign: .center,
                              style: GalegosUiDefaut.theme.textTheme.titleMedium,
                            ),
                            content: Text(
                              'Deseja excluir essa marmita?',
                              textAlign: .center,
                              style: GalegosUiDefaut.theme.textTheme.bodySmall,
                            ),
                            actionsAlignment: .center,
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
                                child: Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
                                child: Text('Confirmar'),
                              ),
                            ],
                          );
                        },
                      );
                      return confirm == true;
                    },
                    onDismissed: (_) {
                      controller.apagarMarmita(alimento);
                      controller.refreshLunchboxes();
                    },
                    child: InkWell(
                      splashColor: GalegosUiDefaut.theme.splashColor,
                      onTap: () {
                        controller.setFoodSelected(alimento, widget.selectedSize);
                        final number = NumberFormat('#,##0.00', 'pt_BR');
                        final temHoje = controller.temHoje(alimento);
                        showDialog(
                          context: context,
                          builder: (context) {
                            final nameEC = TextEditingController(text: alimento.name);
                            final descriptionEC = TextEditingController(text: alimento.description);
                            final priceMiniEC = TextEditingController(
                              text: number.format(alimento.pricePerSize['mini']),
                            );
                            final priceMediaEC = TextEditingController(
                              text: number.format(alimento.pricePerSize['media']),
                            );

                            return Form(
                              key: _formKey,
                              child: AlertProductsLunchboxesAdm(
                                isProduct: false,
                                onPressed: () async {
                                  final formValid = _formKey.currentState?.validate() ?? false;
                                  if (formValid) {
                                    final cleanedMini = priceMiniEC.text
                                        .replaceAll('.', '')
                                        .replaceAll(',', '.');
                                    final cleanedMedia = priceMediaEC.text
                                        .replaceAll('.', '')
                                        .replaceAll(',', '.');

                                    await controller.atualizarDadosDaMarmita(
                                      alimento.id,
                                      nameEC.text,
                                      descriptionEC.text,
                                      double.parse(cleanedMini),
                                      double.parse(cleanedMedia),
                                    );

                                    Get.back();
                                  }
                                },
                                description: descriptionEC,
                                value: temHoje,
                                onChanged: (bool value) async {
                                  temHoje.value = value;
                                  await controller.atualizarMarmitasDoDia(alimento.id, alimento);
                                  await controller.refreshLunchboxes();
                                },
                                nameFood: nameEC,
                                priceMini: priceMiniEC,
                                priceMedia: priceMediaEC,
                                items: controller.times
                                    .expand((d) => d.days)
                                    .map(
                                      (e) => MultiSelectCard<String>(
                                        value: e,
                                        label: e[0],
                                        selected: alimento.dayName.contains(e),
                                      ),
                                    )
                                    .toList(),
                                onChangedSection: (allSelectedItems, selectedItem) {
                                  alimento.dayName = allSelectedItems.cast<String>();
                                  controller.addDays.value = allSelectedItems
                                      .map((e) => e)
                                      .toList();
                                },
                              ),
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
                                    style: TextStyle(color: GalegosUiDefaut.colorScheme.error),
                                  ),
                            title: Text(
                              alimento.name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(alimento.description),
                            trailing: Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        // .toList(),
        const SizedBox(height: 50),
      ],
    );
  }
}
