import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/section_header.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:validatorless/validatorless.dart';

class AlertForAddToCart extends StatelessWidget {
  final bool _isProduct;

  const AlertForAddToCart({super.key, required bool isProduct}) : _isProduct = isProduct;

  @override
  Widget build(BuildContext context) {
    return _isProduct ? _products() : _foods();
  }
}

Widget _products() {
  ProductsController controller = Get.find<ProductsController>();
  return AlertDialog(
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
            controller: controller.nameProductEC,
          ),
          GalegosTextFormField(
            colorText: GalegosUiDefaut.colorScheme.tertiary,
            colorBorder: GalegosUiDefaut.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            label: 'Descrição',
            controller: controller.descriptionEC,
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
            controller: controller.priceEC,
          ),
        ],
      ),
    ),
    actions: [
      ElevatedButton(
        style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
        onPressed: () {
          controller.cadastrarNovosProdutos();
          Get.back();
        },
        child: Text('Cadastrar'),
      ),
    ],
  );
}

Widget _foods() {
  final LunchboxesController controller = Get.find<LunchboxesController>();
  return AlertDialog(
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
      'Adiciona Marmita',
      overflow: .ellipsis,
      textAlign: .center,
      style: GalegosUiDefaut.theme.textTheme.titleMedium,
    ),
    content: SingleChildScrollView(
      child: Column(
        spacing: 20,
        children: [
          SectionHeader(
            items: controller.times
                .expand((e) => e.days)
                .map((day) => MultiSelectCard(value: day, label: day[0]))
                .toList(),
            onChanged: (allSelectedItems, selectedItem) {
              controller.addDays.value = allSelectedItems.map((e) => e).toList();
            },
          ),
          GalegosTextFormField(
            colorText: GalegosUiDefaut.colorScheme.tertiary,
            colorBorder: GalegosUiDefaut.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            label: 'Nome da Marmita',
            validator: Validatorless.required('Nome inválido'),
            controller: controller.nomeMarmitaEC,
          ),
          GalegosTextFormField(
            colorText: GalegosUiDefaut.colorScheme.tertiary,
            colorBorder: GalegosUiDefaut.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            label: 'Descrição',
            controller: controller.descricaoEC,
          ),
          GalegosTextFormField(
            colorText: GalegosUiDefaut.colorScheme.tertiary,
            colorBorder: GalegosUiDefaut.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            inputType: .number,
            prefixText: 'R\$ ',
            validator: Validatorless.multiple([
              Validatorless.required('Nome inválido'),
            ]),
            label: 'Preço Marmita Mini',
            controller: controller.precoMiniEC,
          ),
          GalegosTextFormField(
            colorText: GalegosUiDefaut.colorScheme.tertiary,
            colorBorder: GalegosUiDefaut.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            inputType: .number,
            prefixText: 'R\$ ',
            validator: Validatorless.multiple([
              Validatorless.required('Nome inválido'),
            ]),
            label: 'Preço Marmita Média',
            controller: controller.precoMediaEC,
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
        onPressed: () async {
          controller.cadastrarNovasMarmitas();
        },
        child: Text('Cadastrar'),
      ),
    ],
  );
}
