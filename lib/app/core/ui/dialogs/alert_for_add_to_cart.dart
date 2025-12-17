import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/section_header.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:validatorless/validatorless.dart';

class AlertForAddToCart extends StatelessWidget {
  final bool _isProduct;

  const AlertForAddToCart({super.key, required bool isProduct})
    : _isProduct = isProduct;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _isProduct ? _products(theme) : _foods(theme);
  }
}

Widget _products(ThemeData theme) {
  ProductsController controller = Get.find<ProductsController>();
  return AlertDialog(
    backgroundColor: theme.colorScheme.surface,
    titlePadding: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    actionsPadding: const EdgeInsets.only(
      top: 20,
      left: 20,
      right: 20,
      bottom: 15,
    ),
    icon: Align(
      alignment: .bottomRight,
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.close),
        color: theme.colorScheme.tertiary,
      ),
    ),
    title: Text(
      'Adiciona Produto',
      overflow: .ellipsis,
      textAlign: .center,
      style: theme.textTheme.titleMedium,
    ),
    content: SingleChildScrollView(
      child: Column(
        spacing: 20,
        children: [
          Obx(() {
            return DropdownButtonFormField<String>(
              dropdownColor: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(5),
              decoration: InputDecoration(
                labelText: 'Categoria',
                labelStyle: TextStyle(
                  color: theme.colorScheme.tertiary,
                ),
                hint: Text(
                  'Selecione',
                  style: TextStyle(color: theme.colorScheme.tertiary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.colorScheme.tertiary,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
              style: TextStyle(color: theme.colorScheme.tertiary),
              selectedItemBuilder: (context) {
                return controller.category.map((c) {
                  return Text(
                    c.name,
                    style: TextStyle(
                      color: theme.colorScheme.tertiary,
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
                          color: theme.colorScheme.tertiary,
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
              validator: Validatorless.required('Selecione uma categoria'),
            );
          }),
          GalegosTextFormField(
            colorText: theme.colorScheme.tertiary,
            colorBorder: theme.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            label: 'Nome do Produto',
            validator: Validatorless.required('Nome inválido'),
            controller: controller.nameProductEC,
          ),
          GalegosTextFormField(
            colorText: theme.colorScheme.tertiary,
            colorBorder: theme.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            label: 'Descrição',
            controller: controller.descriptionEC,
          ),
          GalegosTextFormField(
            colorText: theme.colorScheme.tertiary,
            colorBorder: theme.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            inputType: .number,
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
        style: theme.elevatedButtonTheme.style,
        onPressed: () {
          controller.cadastrarNovosProdutos();
          Get.back();
        },
        child: Text('Cadastrar'),
      ),
    ],
  );
}

Widget _foods(ThemeData theme) {
  final LunchboxesController controller = Get.find<LunchboxesController>();
  return AlertDialog(
    icon: Align(
      alignment: .bottomRight,
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.close),
        color: theme.colorScheme.tertiary,
      ),
    ),
    title: Text(
      'Adiciona Marmita',
      overflow: .ellipsis,
      textAlign: .center,
      style: theme.textTheme.titleMedium,
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
              controller.addDays.value = allSelectedItems
                  .map((e) => e)
                  .toList();
            },
          ),
          GalegosTextFormField(
            colorText: theme.colorScheme.tertiary,
            colorBorder: theme.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            label: 'Nome da Marmita',
            validator: Validatorless.required('Nome inválido'),
            controller: controller.nomeMarmitaEC,
          ),
          GalegosTextFormField(
            colorText: theme.colorScheme.tertiary,
            colorBorder: theme.colorScheme.tertiary,
            floatingLabelBehavior: .auto,
            enabled: true,
            label: 'Descrição',
            controller: controller.descricaoEC,
          ),
          GalegosTextFormField(
            colorText: theme.colorScheme.tertiary,
            colorBorder: theme.colorScheme.tertiary,
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
            colorText: theme.colorScheme.tertiary,
            colorBorder: theme.colorScheme.tertiary,
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
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        onPressed: () async {
          controller.cadastrarNovasMarmitas();
        },
        child: Text('Cadastrar'),
      ),
    ],
  );
}
