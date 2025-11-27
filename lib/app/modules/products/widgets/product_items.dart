import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_products_lunchboxes_adm.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_items.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

class ProductItems extends GetView<ProductsController> {
  const ProductItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: controller.admin ? _ProductsAdmin() : _ProductsClient(controller: controller),
    );
  }
}

class _ProductsClient extends StatelessWidget {
  const _ProductsClient({required this.controller});

  final ProductsController controller;

  @override
  Widget build(BuildContext context) {
    final category = controller.category;
    final items = controller.items;
    return Column(
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
          filtered = items.where((p) => p.categoryId == c.name && p.temHoje).toList();
        }

        if (filtered.isEmpty) return SizedBox.shrink();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 30.0),
              child: Text(c.name, style: GalegosUiDefaut.theme.textTheme.titleLarge),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 100),
              width: context.width,
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                children: filtered
                    .where((e) => e.categoryId == c.name)
                    .map(
                      (e) => CardItems(
                        width: 190,
                        height: 310,
                        imageHeight: 130,
                        titulo: e.name,
                        preco: FormatterHelper.formatCurrency(e.price),
                        descricao: e.description,
                        image: (e.image.isNotEmpty) ? e.image : '',
                        onPressed: () {
                          controller.setSelectedItem(e);
                          final idItem = controller.carrinhoServices.getById(e.id);
                          if (idItem == null) {
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
                          } else {
                            controller.addProductUnit();
                            controller.addItemsToCart();
                          }

                          log('Item clicado: ${e.name} - ${e.price}');
                        },
                        onTap: () {
                          controller.setSelectedItem(e);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialogDefault(
                                visible: controller.quantity > 0 && controller.alreadyAdded == true,
                                plusMinus: Obx(() {
                                  return GalegosPlusMinus(
                                    addCallback: controller.addProductUnit,
                                    removeCallback: controller.removeProductUnit,
                                    quantityUnit: controller.quantity,
                                  );
                                }),
                                item: e,
                                onPressed: () {
                                  final idItem = controller.carrinhoServices.getById(e.id);

                                  if (idItem == null) {
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
                                    Get.close(0);
                                    log('Item clicado: ${e.name} - ${e.price}');
                                  } else {
                                    controller.addItemsToCart();
                                    Get.close(0);
                                    log('Item clicado: ${e.name} - ${e.price}');
                                  }
                                },
                                onPressedR: () {
                                  controller.removeAllProductsUnit();
                                  controller.addItemsToCart();
                                },
                              );
                            },
                          );
                        },
                        styleTitle: GalegosUiDefaut.theme.textTheme.titleMedium,
                        styleDescricao: GalegosUiDefaut.theme.textTheme.bodyLarge,
                        stylePreco: GalegosUiDefaut.textProduct.titleMedium,
                        isProduct: true,
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}

class _ProductsAdmin extends StatefulWidget {
  @override
  State<_ProductsAdmin> createState() => _ProductsAdminState();
}

class _ProductsAdminState extends GalegosState<_ProductsAdmin, ProductsController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final category = controller.category;
    final items = controller.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: category.map((c) {
        final List<ProductModel> filtered;
        final categoriaSelecionada = controller.categorySelected.value?.name;

        if (categoriaSelecionada != null) {
          filtered = items
              .where(
                (p) =>
                    p.categoryId == c.name &&
                    p.categoryId == (controller.categorySelected.value?.name),
              )
              .toList();
        } else {
          filtered = items.where((p) => p.categoryId == c.name).toList();
        }

        if (filtered.isEmpty) return SizedBox.shrink();

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 16.0),
              child: Text(c.name, style: GalegosUiDefaut.theme.textTheme.titleLarge),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 100),
              width: context.width,
              child: Column(
                children: filtered
                    .where((e) => e.categoryId == c.name)
                    .map(
                      (e) => Card(
                        elevation: 2,
                        color: GalegosUiDefaut.theme.cardTheme.color,
                        clipBehavior: Clip.hardEdge,
                        child: Dismissible(
                          background: Container(
                            color: GalegosUiDefaut.colorScheme.error,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          key: ValueKey(e.id),
                          onDismissed: (_) {
                            controller.deletarProd(e);
                            controller.refreshProducts();
                          },
                          child: InkWell(
                            splashColor: GalegosUiDefaut.theme.splashColor,
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              final number = NumberFormat('#,##0.00', 'pt_BR');
                              controller.setSelectedItem(e);
                              final temHoje = controller.temHoje(e);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final nameEC = TextEditingController(text: e.name);
                                  final descriptionEC = TextEditingController(text: e.description);
                                  final categoryEC = TextEditingController(text: e.categoryId);
                                  final priceEC = TextEditingController(
                                    text: number.format(e.price),
                                  );
                                  return Form(
                                    key: _formKey,
                                    child: AlertProductsLunchboxesAdm(
                                      category: categoryEC,
                                      nameProduct: nameEC,
                                      description: descriptionEC,
                                      price: priceEC,
                                      onPressed: () {
                                        final formValid =
                                            _formKey.currentState?.validate() ?? false;
                                        if (formValid) {
                                          final cleaned = priceEC.text
                                              .replaceAll('.', '')
                                              .replaceAll(',', '.');
                                          controller.updateData(
                                            e.id,
                                            e.categoryId,
                                            descriptionEC.text,
                                            nameEC.text,
                                            double.parse(cleaned),
                                          );
                                        }
                                        Get.back();
                                      },
                                      value: temHoje,
                                      onChanged: (value) async {
                                        temHoje.value = value;
                                        await controller.updateListItems(e.id, e);
                                        await controller.refreshProducts();
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: ListTile(
                              textColor: Colors.black87,
                              leading: e.temHoje
                                  ? Text('Ativo', style: TextStyle(color: Colors.green))
                                  : Text(
                                      'Inativo',
                                      style: TextStyle(color: GalegosUiDefaut.colorScheme.error),
                                    ),
                              title: Text(
                                e.name,
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                e.description ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                FormatterHelper.formatCurrency(e.price),
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 45),
          ],
        );
      }).toList(),
    );
  }
}
