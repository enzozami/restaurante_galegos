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
                        icon: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              log('fechei');
                              Get.back();
                            },
                            icon: Icon(Icons.close),
                            color: Colors.black,
                          ),
                        ),
                        title: Text('Adicionar produto'),
                        content: SingleChildScrollView(
                          child: Column(
                            spacing: 20,
                            children: [
                              Obx(() {
                                return DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Categoria',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                  initialValue: controller.categoryId.value?.isEmpty ?? false
                                      ? null
                                      : controller.categoryId.value,
                                  items: controller.category
                                      .map(
                                        (c) => DropdownMenuItem<String>(
                                          value: c.name,
                                          child: Text(c.name),
                                        ),
                                      )
                                      .toList(),
                                  hint: const Text('Selecione'),
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
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                label: 'Nome do Produto',
                                validator: Validatorless.required('Nome inválido'),
                                controller: nomeProdutoEC,
                              ),
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                label: 'Descrição',
                                controller: descricaoEC,
                              ),
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                            onPressed: () {
                              final formValid = formKey.currentState?.validate() ?? false;
                              if (formValid) {
                                final name = nomeProdutoEC.text;
                                final price = precoEC.text;
                                final description = descricaoEC.text;
                                controller.cadastrar(name, double.parse(price), description);
                              }
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
              Text(
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
