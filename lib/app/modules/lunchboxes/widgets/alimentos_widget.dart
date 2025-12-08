import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_items.dart';
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
    return SizedBox(
      width: double.infinity,
      child: controller.loading.value
          ? Wrap(
              children: List.generate(
                5,
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
                                  controller.exibirDialogoAdicionarAoCarrinho(
                                    alimento: alimento,
                                    context: context,
                                    size: s,
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
                      return await controller.exibirConfirmacaoDescarte(context, alimento);
                    },
                    onDismissed: (_) {
                      controller.apagarMarmita(alimento);
                      controller.refreshLunchboxes();
                    },
                    child: InkWell(
                      splashColor: GalegosUiDefaut.theme.splashColor,
                      onTap: () {
                        controller.handleFoodTap(context, alimento, widget.selectedSize);
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
