import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import './detail_product_controller.dart';

class DetailProductPage extends GetView<DetailProductController> {
  const DetailProductPage({super.key});

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
  required DetailProductController controller,
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
              'Detalhe do Produto',
              style: theme.textTheme.headlineLarge,
            ),
          ),
          (controller.productSelected.value.image.isNotEmpty)
              ? Center(
                  child: Image.network(
                    controller.productSelected.value.image,
                    fit: BoxFit.cover,
                    width: context.widthTransformer(reducedBy: 10),
                    height: context.height * 0.25,
                  ),
                )
              : SizedBox.shrink(),
          Center(
            child: SizedBox(
              width: context.widthTransformer(reducedBy: 10),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 10),
                  child: Text(
                    controller.productSelected.value.name,
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
                    controller.productSelected.value.description ?? '',
                    style: theme.textTheme.bodyMedium,
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
                    FormatterHelper.formatCurrency(controller.productSelected.value.price),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GalegosButtonDefault(
              label: 'Editar',
              onPressed: () => controller.pressForEditOrCancel(),
              width: context.widthTransformer(reducedBy: 10),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _edit({
  required BuildContext context,
  required ThemeData theme,
  required DetailProductController controller,
}) {
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
              'Editando Produto',
              style: theme.textTheme.headlineLarge,
            ),
          ),
          (controller.productSelected.value.image.isNotEmpty)
              ? Center(
                  child: Image.network(
                    controller.productSelected.value.image,
                    fit: BoxFit.cover,
                    width: context.widthTransformer(reducedBy: 10),
                    height: context.height * 0.25,
                  ),
                )
              : SizedBox.shrink(),
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
                label: 'Preço',
                inputType: .number,
                controller: controller.newPrice,
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
}
