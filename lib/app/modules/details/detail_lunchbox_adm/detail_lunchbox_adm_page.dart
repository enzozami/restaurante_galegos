import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/section_header.dart';
import './detail_lunchbox_adm_controller.dart';

class DetailLunchboxAdmPage extends GetView<DetailLunchboxAdmController> {
  const DetailLunchboxAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      return Scaffold(
        appBar: GalegosAppBar(context: context),
        extendBodyBehindAppBar: true,
        body: controller.editing.value
            ? _edit(context: context, theme: theme, controller: controller)
            : _detail(context: context, theme: theme, controller: controller),
      );
    });
  }
}

Widget _detail({
  required BuildContext context,
  required ThemeData theme,
  required DetailLunchboxAdmController controller,
}) {
  return Obx(() {
    return SingleChildScrollView(
      child: Column(
        spacing: 20,
        crossAxisAlignment: .start,
        children: [
          SafeArea(child: Container()),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
            child: Text(
              'Detalhe da Marmita',
              style: theme.textTheme.headlineLarge,
            ),
          ),
          (controller.foodSelected.value.image.isNotEmpty)
              ? Center(
                  child: Image.network(
                    controller.foodSelected.value.image,
                    fit: BoxFit.cover,
                    width: context.widthTransformer(reducedBy: 10),
                    height: context.height * 0.25,
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 40,
            ),
            child: Text(
              'Dias da semana:',
              style: theme.textTheme.titleSmall,
            ),
          ),
          Center(
            child: IgnorePointer(
              ignoring: true,
              child: SectionHeader(
                items: controller.foodSelected.value.dayName
                    .map(
                      (d) => MultiSelectCard<String>(
                        value: d,
                        label: d,
                        selected: controller.foodSelected.value.dayName.contains(d),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      ),
                    )
                    .toList(),
                onChanged: (_, _) {},
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: context.widthTransformer(reducedBy: 10),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 10),
                  child: Text(
                    controller.foodSelected.value.name,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: context.widthTransformer(reducedBy: 10),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    controller.foodSelected.value.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ),

          Column(
            spacing: 20,
            children: controller.foodSelected.value.pricePerSize.entries
                .map(
                  (size) => Center(
                    child: SizedBox(
                      width: context.widthTransformer(reducedBy: 10),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                'Preço ${size.key.toUpperCase()}:',
                                style: theme.textTheme.bodyLarge,
                              ),
                              Text(
                                FormatterHelper.formatCurrency(
                                  size.value,
                                ),
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          Center(
            child: GalegosButtonDefault(
              label: 'Editar',
              onPressed: () => controller.pressForEditOrCancel(),
              width: context.widthTransformer(reducedBy: 10),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  });
}

Widget _edit({
  required BuildContext context,
  required ThemeData theme,
  required DetailLunchboxAdmController controller,
}) {
  return Obx(() {
    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: .start,
          spacing: 20,
          children: [
            SafeArea(child: Container()),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
              child: Text(
                'Editando Marmita',
                style: theme.textTheme.headlineLarge,
              ),
            ),
            (controller.foodSelected.value.image.isNotEmpty)
                ? Center(
                    child: Image.network(
                      controller.foodSelected.value.image,
                      fit: BoxFit.cover,
                      width: context.widthTransformer(reducedBy: 10),
                      height: context.height * 0.25,
                    ),
                  )
                : SizedBox.shrink(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: SectionHeader(
                  items: controller.times
                      .expand((d) => d.days)
                      .map(
                        (e) => MultiSelectCard<String>(
                          value: e,
                          label: e[0],
                          selected: controller.foodSelected.value.dayName.contains(e),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      )
                      .toList(),
                  onChanged: controller.onChangedSelectionFunctionEditing,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: GalegosTextFormField(
                  floatingLabelBehavior: .auto,
                  prefix: false,
                  suffix: false,
                  label: 'Nome do Produto',
                  controller: controller.newName,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: GalegosTextFormField(
                  floatingLabelBehavior: .auto,
                  inputType: .multiline,
                  minLines: 2,
                  maxLines: 5,
                  prefix: false,
                  suffix: false,
                  label: 'Descrição',
                  controller: controller.newDescription,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: GalegosTextFormField(
                  floatingLabelBehavior: .auto,
                  prefix: false,
                  suffix: false,
                  inputType: .number,
                  label: 'Preço Mini',
                  controller: controller.newPriceMini,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: GalegosTextFormField(
                  floatingLabelBehavior: .auto,
                  inputType: .number,
                  prefix: false,
                  suffix: false,
                  label: 'Preço Media',
                  controller: controller.newPriceMedia,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'Ativo',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Switch.adaptive(
                          value: controller.valueTemHoje.value,
                          onChanged: (value) => controller.changeValueTemHoje(value),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: .spaceAround,
              children: [
                Center(
                  child: GalegosButtonDefault(
                    width: context.widthTransformer(reducedBy: 60),
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        theme.colorScheme.error,
                      ),
                      foregroundColor: WidgetStatePropertyAll<Color>(
                        theme.colorScheme.onError,
                      ),
                    ),
                    label: 'Cancelar',
                    onPressed: () => controller.pressForEditOrCancel(),
                  ),
                ),
                Center(
                  child: GalegosButtonDefault(
                    width: context.widthTransformer(reducedBy: 60),
                    label: 'Salvar',
                    onPressed: () async => await controller.atualizarDados(),
                    // onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  });
}
