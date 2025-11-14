import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_products_lunchboxes_adm.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

class ProductItems extends GetView<ProductsController> {
  const ProductItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Obx(() {
        final category = controller.category;
        final items = controller.items;
        return Visibility(
          visible: controller.admin != true,
          replacement: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: category.map((c) {
              final produtosDaCategoria =
                  items.where((p) => p.categoryId == c.name).toSet().toList();

              if (produtosDaCategoria.isEmpty) return SizedBox.shrink();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 16.0),
                    child: Text(
                      c.name,
                      style: GalegosUiDefaut.theme.textTheme.titleLarge,
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: GalegosUiDefaut.theme.cardTheme.color,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      width: context.width,
                      child: Column(
                        children: produtosDaCategoria
                            .where((e) => e.categoryId == c.name)
                            .map(
                              (e) => Card(
                                elevation: 2,
                                color: GalegosUiDefaut.theme.cardTheme.color,
                                child: InkWell(
                                  splashColor: GalegosUiDefaut.theme.splashColor,
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    controller.setSelectedItem(e);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertProductsLunchboxesAdm(
                                          title: 'ATENÇÃO',
                                          body: e.temHoje
                                              ? 'Deseja desabilitar esse produto?'
                                              : 'Deseja habilitar esse produto?',
                                          onPressed: () async {
                                            controller.updateListItems(e.id, e);
                                            Get.back();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: ListTile(
                                    textColor: Colors.black87,
                                    leading: e.temHoje
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
                                      e.name,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      e.description ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                      FormatterHelper.formatCurrency(e.price),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }).toList(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: category.map((c) {
              final List<ProductModel> filtered;
              final categoriaSelecionada = controller.categorySelected.value?.name;

              if (categoriaSelecionada != null) {
                filtered = items
                    .where(
                      (p) =>
                          p.categoryId == c.name &&
                          p.categoryId == (controller.categorySelected.value?.name) &&
                          p.temHoje,
                    )
                    .toList();
              } else {
                filtered = items
                    .where(
                      (p) => p.categoryId == c.name && p.temHoje,
                    )
                    .toList();
              }

              if (filtered.isEmpty) return SizedBox.shrink();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 16.0),
                    child: Text(
                      c.name,
                      style: GalegosUiDefaut.theme.textTheme.titleLarge,
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: GalegosUiDefaut.theme.cardTheme.color,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      width: context.width,
                      child: Column(
                        children: filtered
                            .where((e) => e.categoryId == c.name)
                            .map(
                              (e) => Card(
                                elevation: 2,
                                color: GalegosUiDefaut.theme.cardTheme.color,
                                child: InkWell(
                                  splashColor: GalegosUiDefaut.theme.splashColor,
                                  borderRadius: BorderRadius.circular(8),
                                  // onTap: () => _showItemDetailDialog(context, e),
                                  onTap: () {
                                    controller.setSelectedItem(e);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialogDefault(
                                          visible: controller.quantity > 0 &&
                                              controller.alreadyAdded == true,
                                          plusMinus: Obx(() {
                                            return GalegosPlusMinus(
                                              addCallback: controller.addProductUnit,
                                              removeCallback: controller.removeProductUnit,
                                              quantityUnit: controller.quantity,
                                            );
                                          }),
                                          item: e,
                                          onPressed: () {
                                            controller.addItemsToCart();
                                            Get.snackbar(
                                              'Item: ${e.name}',
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
                                            log('Item clicado: ${e.name} - ${e.price}');
                                          },
                                          onPressedR: () {
                                            controller.removeAllProductsUnit();
                                            controller.addItemsToCart();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        textColor: Colors.black87,
                                        title: Text(
                                          e.name,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: Text(
                                          e.description ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Text(
                                          FormatterHelper.formatCurrency(e.price),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                        child: const Divider(
                                            height: 0.5, thickness: 1, color: Colors.black26),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
