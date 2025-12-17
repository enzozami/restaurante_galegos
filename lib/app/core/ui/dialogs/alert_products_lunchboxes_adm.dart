import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
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
            onChangedSection:
                onChangedSection ?? (List<String> p1, String p2) {},
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
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      // backgroundColor: theme.colors['fundo'],
      // titlePadding: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
      // contentPadding: const EdgeInsets.only(
      //   top: 15,
      //   left: 10,
      //   right: 15,
      //   bottom: 10,
      // ),
      // actionsPadding: const EdgeInsets.only(
      //   top: 20,
      //   left: 0,
      //   right: 20,
      //   bottom: 20,
      // ),
      icon: Align(
        alignment: .centerRight,
        child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      title: sectionTitle('Editar Produto', theme),
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
                colorBorder: theme.colorScheme.tertiary,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Descrição',
                controller: description,
                colorBorder: theme.colorScheme.tertiary,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Preço',
                inputType: .number,
                controller: price,
                colorBorder: theme.colorScheme.tertiary,
                prefixText: 'R\$ ',
              ),

              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Categoria',
                enabled: false,
                controller: category,
                colorBorder: theme.colorScheme.tertiary,
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
                      activeThumbColor: theme.colorScheme.primary,
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
          style: theme.elevatedButtonTheme.style,
          child: Text('Salvar'),
        ),
      ],
    );
  }
}

Widget sectionTitle(String text, ThemeData theme) => Padding(
  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
  child: Text(
    text,
    style: theme.textTheme.titleMedium,
    textAlign: .center,
  ),
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
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      // backgroundColor: theme.colorScheme.surface,
      // titlePadding: const EdgeInsets.only(
      //   top: 0,
      //   left: 20,
      //   right: 20,
      //   bottom: 0,
      // ),
      // contentPadding: const EdgeInsets.only(
      //   top: 15,
      //   left: 10,
      //   right: 15,
      //   bottom: 10,
      // ),
      // actionsPadding: const EdgeInsets.only(
      //   top: 20,
      //   left: 0,
      //   right: 20,
      //   bottom: 20,
      // ),
      icon: Align(
        alignment: .centerRight,
        child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      title: sectionTitle('Editar Marmita', theme),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            spacing: 20,
            children: [
              SectionHeader(items: items, onChanged: onChangedSection),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Nome',
                controller: nameFood,
                colorBorder: theme.colorScheme.tertiary,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Descrição',
                controller: description,
                colorBorder: theme.colorScheme.tertiary,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Preço (Mini)',
                inputType: .number,
                controller: priceMini,
                colorBorder: theme.colorScheme.tertiary,
                prefixText: 'R\$ ',
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Preço (Media)',
                inputType: .number,
                controller: priceMedia,
                colorBorder: theme.colorScheme.tertiary,
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
                      activeThumbColor: theme.colorScheme.primary,
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
          style: theme.elevatedButtonTheme.style,
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
