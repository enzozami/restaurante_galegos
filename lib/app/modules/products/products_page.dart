import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_header.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_items.dart';
import 'package:validatorless/validatorless.dart';
import './products_controller.dart';

class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('messagesfwgfswvg ${controller.items}');
    return Scaffold(
      floatingActionButton: controller.admin
          ? FloatingActionButton.extended(
              onPressed: () {
                final nomeProdutoEC = TextEditingController();
                final descricaoEC = TextEditingController();
                final precoEC = TextEditingController();
                final formKey = GlobalKey<FormState>();

                showDialog(
                  context: context,
                  builder: (context) {
                    return Form(
                      key: formKey,
                      child: AlertDialog(
                        backgroundColor: GalegosUiDefaut.colorScheme.onPrimary,
                        titlePadding:
                            const EdgeInsets.only(top: 15, left: 24, right: 24, bottom: 0),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        actionsPadding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Adiciona Produto',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: GalegosUiDefaut.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: GalegosUiDefaut.colorScheme.secondary),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            spacing: 20,
                            children: [
                              Obx(() {
                                return DropdownButtonFormField<String>(
                                  dropdownColor: GalegosUiDefaut.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(30),
                                  decoration: InputDecoration(
                                    labelText: 'Categoria',
                                    labelStyle: TextStyle(
                                      color: GalegosUiDefaut.colorScheme.primary,
                                    ),
                                    hint: Text(
                                      'Selecione',
                                      style: TextStyle(
                                        color: GalegosUiDefaut.colorScheme.primary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: GalegosUiDefaut.colorScheme.primary,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: GalegosUiDefaut.colorScheme.primary,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: GalegosUiDefaut.colorScheme.primary,
                                  ),
                                  selectedItemBuilder: (context) {
                                    return controller.category.map((c) {
                                      return Text(
                                        c.name,
                                        style: TextStyle(
                                          color: GalegosUiDefaut.colorScheme.primary,
                                        ),
                                      );
                                    }).toList();
                                  },
                                  initialValue: controller.categoryId.value?.isEmpty ?? false
                                      ? null
                                      : controller.categoryId.value,
                                  items: controller.category
                                      .map(
                                        (c) => DropdownMenuItem<String>(
                                          value: c.name,
                                          child: Text(
                                            c.name,
                                            style: TextStyle(
                                              color: GalegosUiDefaut.colorScheme.onSecondary,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.categoryId.value = value;
                                    }
                                  },
                                  validator: Validatorless.required(
                                    'Selecione uma categoria',
                                  ),
                                );
                              }),
                              GalegosTextFormField(
                                colorText: GalegosUiDefaut.colorScheme.primary,
                                colorBorder: GalegosUiDefaut.colorScheme.secondary,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabled: true,
                                label: 'Nome do Produto',
                                validator: Validatorless.required('Nome inválido'),
                                controller: nomeProdutoEC,
                              ),
                              GalegosTextFormField(
                                colorText: GalegosUiDefaut.colorScheme.primary,
                                colorBorder: GalegosUiDefaut.colorScheme.secondary,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabled: true,
                                label: 'Descrição',
                                controller: descricaoEC,
                              ),
                              GalegosTextFormField(
                                colorText: GalegosUiDefaut.colorScheme.primary,
                                colorBorder: GalegosUiDefaut.colorScheme.secondary,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabled: true,
                                inputType: TextInputType.numberWithOptions(),
                                validator: Validatorless.multiple([
                                  Validatorless.required('Nome inválido'),
                                ]),
                                label: 'Preço',
                                controller: precoEC,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GalegosUiDefaut.colorScheme.primary,
                              foregroundColor: GalegosUiDefaut.colorScheme.onPrimary,
                            ),
                            onPressed: () {
                              final formValid = formKey.currentState?.validate() ?? false;
                              if (formValid) {
                                final name = nomeProdutoEC.text;
                                final price = precoEC.text;
                                final description = descricaoEC.text;
                                controller.cadastrar(name, double.parse(price), description);
                              }
                              Get.back();
                            },
                            child: Text('Cadastrar'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.add,
                color: GalegosUiDefaut.colorScheme.primary,
              ),
              backgroundColor: GalegosUiDefaut.theme.floatingActionButtonTheme.backgroundColor,
              label: Text(
                'Adicionar',
                style: TextStyle(
                  color: GalegosUiDefaut.colorScheme.primary,
                ),
              ),
            )
          : null,
      body: RefreshIndicator.noSpinner(
        onRefresh: controller.refreshProducts,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              ProductHeader(),
              const SizedBox(
                height: 20,
              ),
              controller.admin
                  ? SizedBox.shrink()
                  : Text(
                      'Selecione algum item para adicionar ao carrinho*',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
              Obx(() {
                if (controller.items.isEmpty) {
                  return SizedBox.shrink();
                }
                return ProductItems();
              })
            ],
          ),
        ),
      ),
    );
  }
}
