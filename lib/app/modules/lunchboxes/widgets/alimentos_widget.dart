import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_items.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';

import '../../../core/ui/cards/card_shimmer.dart';

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
            ? _FoodsAdmin(
                alimentos: alimentos,
                selectedSize: selectedSize ?? '',
              )
            : _FoodClient(
                alimentos: alimentos,
              );
      }),
    );
  }
}

class _FoodClient extends StatelessWidget {
  final LunchboxesController controller = Get.find<LunchboxesController>();
  final List<FoodModel> alimentos;

  _FoodClient({required this.alimentos});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: controller.loading.value
            ? Wrap(
                children: List.generate(
                  5,
                  (_) => CardShimmer(
                    height: 165,
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
                        id: alimento.id,
                        width: context.widthTransformer(reducedBy: 10),
                        height: 180,
                        isProduct: false,
                        imageHeight: alimento.description.isEmpty ? 150 : 130,
                        titulo: alimento.name,
                        image: alimento.image,
                        descricao: alimento.description,
                        onPressed: () {},
                        onTap: () {
                          Get.toNamed('/detail/lunchboxes', arguments: alimento);
                        },
                        styleTitle: theme.textTheme.titleMedium,
                        styleDescricao: theme.textTheme.bodyLarge,
                        stylePreco: theme.textTheme.titleMedium,
                        precoMini: FormatterHelper.formatCurrency(
                          alimento.pricePerSize['mini'] ?? 0,
                        ),
                        precoMedia: FormatterHelper.formatCurrency(
                          alimento.pricePerSize['media'] ?? 0,
                        ),
                        isSelected: controller.foodSelect.value?.id == alimento.id,
                        onTapDown: (_) => controller.handlePress(alimento.id),
                        onTapCancel: () => controller.handlePress(null),
                        onTapUp: (_) => controller.handlePress(null),
                        isPressed: controller.pressingItemId,
                      );
                    })
                    .toList(),
              ),
      );
    });
  }
}

class _FoodsAdmin extends GetView<LunchboxesController> {
  final List<FoodModel> alimentos;
  final String selectedSize;

  _FoodsAdmin({required this.alimentos, required this.selectedSize});

  final controllerCard = MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      return Column(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 100),
            width: context.width,
            child: controller.loading.value
                ? Column(
                    children: List.generate(
                      20,
                      (_) => CardShimmer(
                        height: 90,
                        width: context.width,
                      ).paddingOnly(bottom: 8),
                    ),
                  )
                : Column(
                    children: alimentos.map((alimento) {
                      return Card(
                        elevation: 2,
                        color: theme.cardTheme.color,
                        child: Dismissible(
                          background: Container(
                            color: theme.colorScheme.error,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          key: ValueKey(alimento.id),
                          confirmDismiss: (_) async {
                            return await controller.exibirConfirmacaoDescarte(
                              context,
                              alimento,
                            );
                          },
                          onDismissed: (_) {
                            controller.apagarMarmita(alimento);
                            controller.refreshLunchboxes();
                          },
                          child: InkWell(
                            splashColor: theme.splashColor,
                            onTap: () {
                              controller.handleFoodTap(
                                context,
                                alimento,
                                selectedSize,
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  leading: alimento.temHoje
                                      ? Text(
                                          'Ativo',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : Text(
                                          'Inativo',
                                          style: TextStyle(
                                            color: theme.colorScheme.error,
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
                                  trailing: Icon(Icons.edit_outlined),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 45),
        ],
      );
    });
  }
}


/*
 codigo q tava antes!
 
elevatedButton: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: controller.availableSizes
                              .map(
                                (s) => ElevatedButton(
                                  style: theme.elevatedButtonTheme.style,
                                  onPressed: () {
                                    // controller.exibirDialogoAdicionarAoCarrinho(
                                    //   alimento: alimento,
                                    //   context: context,
                                    //   size: s,
                                    // );
                                    Get.toNamed('/lunchboxes/detail');
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        s[0].toUpperCase() + s.substring(1),
                                        style: theme.textTheme.titleSmall,
                                      ),
                                      Text(
                                        FormatterHelper.formatCurrency(
                                          alimento.pricePerSize[s] ?? 0,
                                        ),
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),

 */