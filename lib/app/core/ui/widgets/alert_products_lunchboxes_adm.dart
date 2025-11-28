import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';

import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/section_header.dart';

class AlertProductsLunchboxesAdm extends StatelessWidget {
  final bool isProduct;
  final VoidCallback onPressed;
  final RxBool value;
  final Function(bool value) onChanged;
  final TextEditingController description;
  final TextEditingController? category;
  final TextEditingController? nameProduct;
  final TextEditingController? price;
  final TextEditingController? nameFood;
  final TextEditingController? priceMini;
  final TextEditingController? priceMedia;
  final List<MultiSelectCard<String>>? items;
  final void Function(List<String>, String)? onChangedSection;

  const AlertProductsLunchboxesAdm({
    super.key,
    required this.isProduct,
    required this.onPressed,
    required this.description,
    required this.value,
    required this.onChanged,
    this.nameProduct,
    this.price,
    this.category,
    this.nameFood,
    this.priceMini,
    this.priceMedia,
    this.items,
    this.onChangedSection,
  });

  @override
  Widget build(BuildContext context) {
    return isProduct
        ? _AlertProduct(
            nameProduct: nameProduct ?? TextEditingController(),
            description: description,
            price: price ?? TextEditingController(),
            category: category ?? TextEditingController(),
            value: value,
            onChanged: onChanged,
            onPressed: onPressed,
          )
        : _AlertFoods(
            // controller: controller ?? MultiSelectController(),
            nameFood: nameFood ?? TextEditingController(),
            description: description,
            priceMini: priceMini ?? TextEditingController(),
            priceMedia: priceMedia ?? TextEditingController(),
            value: value,
            onChanged: onChanged,
            onPressed: onPressed,
            items: items ?? [],
            onChangedSection: onChangedSection ?? (List<String> p1, String p2) {},
          );
  }
}

class _AlertProduct extends StatelessWidget {
  const _AlertProduct({
    required this.nameProduct,
    required this.description,
    required this.price,
    required this.category,
    required this.value,
    required this.onChanged,
    required this.onPressed,
  });

  final TextEditingController nameProduct;
  final TextEditingController description;
  final TextEditingController price;
  final TextEditingController category;
  final RxBool value;
  final Function(bool value) onChanged;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GalegosUiDefaut.colors['fundo'],
      titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      contentPadding: const EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 10),
      actionsPadding: const EdgeInsets.only(top: 20, left: 0, right: 20, bottom: 20),
      title: Row(mainAxisAlignment: .center, children: [sectionTitle('Editar Produto')]),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            spacing: 20,
            children: [
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Nome',
                controller: nameProduct,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Descrição',
                controller: description,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Preço',
                inputType: .number,
                controller: price,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                prefixText: 'R\$ ',
              ),

              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Categoria',
                enabled: false,
                controller: category,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
              ),
              Divider(),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text('Ativo'),
                  Obx(() {
                    return Switch(
                      value: value.value,
                      onChanged: onChanged,
                      activeThumbColor: GalegosUiDefaut.colors['primaria'],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: onPressed,
          style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
          child: Text('Salvar'),
        ),
      ],
    );
  }
}

Widget sectionTitle(String text) => Padding(
  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
  child: Text(text, style: GalegosUiDefaut.theme.textTheme.titleMedium),
);

class _AlertFoods extends StatelessWidget {
  const _AlertFoods({
    required this.nameFood,
    required this.description,
    required this.priceMini,
    required this.priceMedia,
    required this.value,
    required this.onChanged,
    required this.onPressed,
    required this.items,
    required this.onChangedSection,
  });
  final TextEditingController nameFood;
  final TextEditingController description;
  final TextEditingController priceMini;
  final TextEditingController priceMedia;
  final RxBool value;
  final Function(bool value) onChanged;
  final VoidCallback onPressed;

  final List<MultiSelectCard<String>> items;
  final void Function(List<String>, String) onChangedSection;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GalegosUiDefaut.colors['fundo'],
      titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      contentPadding: const EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 10),
      actionsPadding: const EdgeInsets.only(top: 20, left: 0, right: 20, bottom: 20),
      title: Row(mainAxisAlignment: .center, children: [sectionTitle('Editar Marmita')]),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            spacing: 20,
            children: [
              SectionHeader(items: items, onChanged: onChangedSection),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Nome',
                controller: nameFood,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Descrição',
                controller: description,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Preço (Mini)',
                inputType: .number,
                controller: priceMini,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                prefixText: 'R\$ ',
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Preço (Media)',
                inputType: .number,
                controller: priceMedia,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                prefixText: 'R\$ ',
              ),
              Divider(),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text('Ativo'),
                  Obx(() {
                    return Switch(
                      value: value.value,
                      onChanged: onChanged,
                      activeThumbColor: GalegosUiDefaut.colors['primaria'],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: onPressed,
          style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
