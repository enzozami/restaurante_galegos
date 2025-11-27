import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';

class AlertProductsLunchboxesAdm extends StatelessWidget {
  final VoidCallback onPressed;
  final TextEditingController category;
  final TextEditingController nameProduct;
  final TextEditingController description;
  final TextEditingController price;
  final Function(bool value) onChanged;
  final RxBool value;

  const AlertProductsLunchboxesAdm({
    super.key,
    required this.onPressed,
    required this.category,
    required this.nameProduct,
    required this.description,
    required this.price,
    required this.onChanged,
    required this.value,
  });

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
