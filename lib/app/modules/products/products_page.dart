import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
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
      floatingActionButton: controller.admin ? _FloatingActionButtonAdmin() : null,
      body: RefreshIndicator(
        onRefresh: controller.refreshProducts,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              ProductHeader(),
              const SizedBox(height: 20),
              controller.admin
                  ? SizedBox.shrink()
                  : Center(
                      child: Text(
                        'Selecione algum item para adicionar ao carrinho*',
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
                      ),
                    ),
              Obx(() {
                if (controller.items.isEmpty) {
                  return SizedBox.shrink();
                }
                return ProductItems();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingActionButtonAdmin extends StatefulWidget {
  const _FloatingActionButtonAdmin();

  @override
  State<_FloatingActionButtonAdmin> createState() => _FloatingActionButtonAdminState();
}

class _FloatingActionButtonAdminState
    extends GalegosState<_FloatingActionButtonAdmin, ProductsController> {
  final formKey = GlobalKey<FormState>();
  final nomeProdutoEC = TextEditingController();
  final descricaoEC = TextEditingController();
  final precoEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nomeProdutoEC.dispose();
    descricaoEC.dispose();
    precoEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Form(
              key: formKey,
              child: AlertDialog(
                backgroundColor: GalegosUiDefaut.colors['fundo'],
                titlePadding: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                actionsPadding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
                icon: Align(
                  alignment: .bottomRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                    color: GalegosUiDefaut.colorScheme.tertiary,
                  ),
                ),
                title: Text(
                  'Adiciona Produto',
                  overflow: .ellipsis,
                  textAlign: .center,
                  style: GalegosUiDefaut.theme.textTheme.titleMedium,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    children: [
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          dropdownColor: GalegosUiDefaut.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(5),
                          decoration: InputDecoration(
                            labelText: 'Categoria',
                            labelStyle: TextStyle(color: GalegosUiDefaut.colorScheme.tertiary),
                            hint: Text(
                              'Selecione',
                              style: TextStyle(color: GalegosUiDefaut.colorScheme.tertiary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: GalegosUiDefaut.colorScheme.tertiary),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: GalegosUiDefaut.colorScheme.tertiary),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: GalegosUiDefaut.colorScheme.tertiary),
                            ),
                          ),
                          style: TextStyle(color: GalegosUiDefaut.colorScheme.tertiary),
                          selectedItemBuilder: (context) {
                            return controller.category.map((c) {
                              return Text(
                                c.name,
                                style: TextStyle(color: GalegosUiDefaut.colorScheme.tertiary),
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
                                    style: TextStyle(color: GalegosUiDefaut.colorScheme.tertiary),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.categoryId.value = value;
                            }
                          },
                          validator: Validatorless.required('Selecione uma categoria'),
                        );
                      }),
                      GalegosTextFormField(
                        colorText: GalegosUiDefaut.colorScheme.tertiary,
                        colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                        floatingLabelBehavior: .auto,
                        enabled: true,
                        label: 'Nome do Produto',
                        validator: Validatorless.required('Nome inválido'),
                        controller: nomeProdutoEC,
                      ),
                      GalegosTextFormField(
                        colorText: GalegosUiDefaut.colorScheme.tertiary,
                        colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                        floatingLabelBehavior: .auto,
                        enabled: true,
                        label: 'Descrição',
                        controller: descricaoEC,
                      ),
                      GalegosTextFormField(
                        colorText: GalegosUiDefaut.colorScheme.tertiary,
                        colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                        floatingLabelBehavior: .auto,
                        enabled: true,
                        inputType: TextInputType.number,
                        prefixText: 'R\$ ',
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
                    style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
                    onPressed: () {
                      final formValid = formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        final name = nomeProdutoEC.text;
                        final price = precoEC.text;
                        final description = descricaoEC.text;
                        controller.cadastrarNovosProdutos(name, double.parse(price), description);
                      }
                      nomeProdutoEC.clear();
                      descricaoEC.clear();
                      precoEC.clear();
                      controller.refreshProducts();
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
      icon: Icon(Icons.add),
      backgroundColor: GalegosUiDefaut.theme.floatingActionButtonTheme.backgroundColor,
      foregroundColor: GalegosUiDefaut.theme.floatingActionButtonTheme.foregroundColor,
      label: Text('Adicionar'),
    );
  }
}
