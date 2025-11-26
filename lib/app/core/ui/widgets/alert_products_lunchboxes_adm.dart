import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';

class AlertProductsLunchboxesAdm extends StatelessWidget {
  final VoidCallback onPressedEdit;
  final VoidCallback onPressed;
  final String category;
  final String nameProduct;
  final String description;
  final String price;
  final bool isEditing;
  final Function(bool) onChanged;
  final bool temHoje;

  const AlertProductsLunchboxesAdm({
    super.key,
    required this.onPressed,
    required this.category,
    required this.nameProduct,
    required this.description,
    required this.price,
    required this.isEditing,
    required this.onPressedEdit,
    required this.onChanged,
    required this.temHoje,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GalegosUiDefaut.colors['fundo'],
      titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      contentPadding: const EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 10),
      actionsPadding: const EdgeInsets.only(top: 20, left: 0, right: 20, bottom: 20),
      title: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          sectionTitle(category),
          Switch(
            //! CONTINUAR FAZENDO O SWITCH E A LOGICA
            value: temHoje,
            onChanged: onChanged,
            activeThumbColor: GalegosUiDefaut.colors['primaria'],
          ),
        ],
      ),
      content: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          infoLine('Nome: ', nameProduct),
          Visibility(
            visible: isEditing,
            replacement: SizedBox.shrink(),
            child: GalegosTextFormField(floatingLabelBehavior: .always),
          ),
          Divider(),
          infoLine('Descrição: ', description),
          Visibility(
            visible: isEditing,
            replacement: SizedBox.shrink(),
            child: GalegosTextFormField(floatingLabelBehavior: .always),
          ),
          Divider(),
          infoLine('Preço: ', price),
          Visibility(
            visible: isEditing,
            replacement: SizedBox.shrink(),
            child: GalegosTextFormField(floatingLabelBehavior: .always),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onPressedEdit,
          icon: isEditing ? Icon(Icons.close) : Icon(Icons.edit),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
          child: Text('Fechar'),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
          child: Text('Confirmar'),
        ),
      ],
    );
  }
}

Widget sectionTitle(String text) => Padding(
  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
  child: Text(text, style: GalegosUiDefaut.theme.textTheme.titleMedium),
);

Widget infoLine(String label, String value, {bool bold = false}) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
  child: Text(
    '$label$value',
    style: bold
        ? TextStyle(
            color: GalegosUiDefaut.colors['texto'],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )
        : GalegosUiDefaut.theme.textTheme.bodyLarge,
  ),
);
