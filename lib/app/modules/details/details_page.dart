import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import './details_controller.dart';

class DetailsPage extends GetView<DetailsController> {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GalegosAppBar(context: context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        return (controller.sizeSelected.value == '')
            ? SizedBox.shrink()
            : SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: _adicionarNaMarmita(context, controller),
              );
      }),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: .start,
            children: [
              SafeArea(child: Container()),
              Center(
                child: Image.network(
                  controller.food.image,
                  width: context.widthTransformer(reducedBy: 10),
                  height: 250,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  controller.food.name,
                  style: theme.textTheme.headlineLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 10),
                child: Text(
                  controller.food.description,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: .spaceAround,
                  children: controller.food.pricePerSize.keys.map((size) {
                    final isSelected = controller.sizeSelected.value == size;
                    return GalegosButtonDefault(
                      label: size.toUpperCase(),
                      width: context.widthTransformer(reducedBy: 60),
                      style: isSelected
                          ? theme.elevatedButtonTheme.style
                          : ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.grey[500],
                            ),
                      onPressed: () => controller.changeSizeSelected(size),
                    );
                  }).toList(),
                ),
              ),
              (controller.sizeSelected.value == '')
                  ? SizedBox.shrink()
                  : _foodDetailsBySelectedSize(theme, context),
            ],
          ),
        );
      }),
    );
  }

  Widget _foodDetailsBySelectedSize(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: .spaceAround,
          spacing: 30,
          children: [
            Text(
              FormatterHelper.formatCurrency(controller.price),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            GalegosPlusMinus(
              addCallback: controller.adicionarQuantidade,
              removeCallback: controller.removerQuantidade,
              quantityUnit: controller.quantity,
            ),
          ],
        ),
        Divider(
          color: AppColors.tertiary,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'Adicionais',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Column(), //! lista de adicionais [vem da api]
        CheckboxListTile.adaptive(
          value: false,
          onChanged: (value) {},
          title: Text('OI'),
          controlAffinity: .leading,
          subtitle: Text('R\$ 10,00'),
        ),
        Divider(
          color: AppColors.tertiary,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'Guarnições',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Column(), //! lista de guarnições [vem da api]
        Divider(
          color: AppColors.tertiary,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'Observações',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        GalegosTextFormField(
          floatingLabelBehavior: .never,
          maxLines: 5,
          minLines: 3,
          inputType: .multiline,
          controller: controller.observacoes,
        ),
        Divider(
          color: AppColors.tertiary,
        ),
        Divider(
          color: AppColors.tertiary,
        ),
        Row(
          mainAxisAlignment: .spaceAround,
          children: [
            Text(
              'Total:',
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              FormatterHelper.formatCurrency(controller.totalPrice),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        //! ENQUANTO NAO TEM OS ADICIONAIS E AS GUARNIÇÕES NA API
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}

Widget _adicionarNaMarmita(
  BuildContext context,
  DetailsController controller,
) {
  final ThemeData theme = Theme.of(context);
  return FloatingActionButton.extended(
    backgroundColor: theme.primaryColor,
    onPressed: () => controller.exibirDialogoAdicionarAoCarrinho(
      context: context,
    ),
    label: (controller.itemNoCarrinho() != null)
        ? Text(
            "ATUALIZAR CARRINHO - ${FormatterHelper.formatCurrency(controller.totalPrice)}",
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          )
        : Text(
            "ADICIONAR AO CARRINHO - ${FormatterHelper.formatCurrency(controller.totalPrice)}",
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
  );
}
