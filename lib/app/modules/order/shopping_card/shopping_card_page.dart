import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_shimmer.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/widgets/list_shopping_card.dart';
import 'package:validatorless/validatorless.dart';
import 'shopping_card_controller.dart';

class ShoppingCardPage extends StatefulWidget {
  const ShoppingCardPage({super.key});

  @override
  State<ShoppingCardPage> createState() => _ShoppingCardPageState();
}

class _ShoppingCardPageState extends GalegosState<ShoppingCardPage, ShoppingCardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          return Visibility(
            visible: controller.products.isNotEmpty,
            replacement: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.heightTransformer(reducedBy: 60)),
                  Center(
                    child: Text(
                      'Nenhum item no carrinho!',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Carrinho', style: GalegosUiDefaut.theme.textTheme.titleLarge),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: const Color.fromRGBO(177, 0, 0, 1)),
                        onPressed: () => controller.reset(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(padding: const EdgeInsets.all(8.0), child: ListShoppingCard()),
                ),
                const SizedBox(height: 30),
                // Spacer(),
                Divider(),
                Form(
                  key: controller.formKey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GalegosTextFormField(
                              icon: IconButton(
                                onPressed: () {
                                  controller.resetCepTaxa();
                                },
                                icon: Icon(Icons.backspace_outlined),
                              ),
                              inputType: .numberWithOptions(decimal: true),
                              floatingLabelBehavior: .auto,
                              label: 'CEP',
                              prefixIcon: Icon(Icons.location_on),
                              onEditingComplete: controller.validationOnReplacement()
                                  ? () {
                                      controller.getCep();
                                    }
                                  : null,
                              mask: controller.cepFormatter,
                              controller: controller.cepEC,
                              validator: Validatorless.required('CEP obrigatório'),
                              onChanged: (value) => controller.cepInput.value = value,
                            ),
                          ),
                          const SizedBox(height: 5),
                          controller.loading.value
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: List.generate(
                                      1,
                                      (_) => CardShimmer(
                                        height: 250,
                                        width: context.widthTransformer(reducedBy: 10),
                                      ),
                                    ),
                                  ),
                                )
                              : Visibility(
                                  visible: controller.addressValidation(),
                                  replacement: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: context.widthTransformer(reducedBy: 10),
                                      child: GalegosButtonDefault(
                                        label: 'Consultar',
                                        icon: Icon(
                                          Icons.search,
                                          color: GalegosUiDefaut.colorScheme.tertiary,
                                        ),
                                        onPressed: controller.validationOnReplacement()
                                            ? () {
                                                controller.getCep();
                                                controller.isOpen.value = true;
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                  child: Visibility(
                                    visible: controller.validationIsOpen(),
                                    replacement: IconButton(
                                      onPressed: () {
                                        controller.closeCard();
                                      },
                                      icon: Align(
                                        alignment: Alignment.center,
                                        child: Icon(Icons.expand_more),
                                      ),
                                    ),
                                    child: _address(context, controller),
                                  ),
                                ),
                          const SizedBox(height: 15),
                          controller.loading.value
                              ? Stack(
                                  children: List.generate(
                                    1,
                                    (_) => CardShimmer(
                                      height: 110,
                                      width: context.widthTransformer(reducedBy: 35),
                                    ),
                                  ),
                                )
                              : _finalizeOrder(context, controller),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget _finalizeOrder(BuildContext context, ShoppingCardController controller) {
  return Visibility(
    visible: controller.addressValidation(),
    replacement: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          FormatterHelper.formatCurrency(controller.totalPay(0) ?? 0),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(' / itens'),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Card(
          elevation: 5,
          color: GalegosUiDefaut.colorScheme.secondary,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Total dos itens: ${FormatterHelper.formatCurrency(controller.totalPay(0) ?? 0)}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Taxa de entrega: ${FormatterHelper.formatCurrency(controller.taxa.value)}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Total a pagar: ${_total(controller)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        GalegosButtonDefault(
          label: 'FINALIZAR',
          width: context.widthTransformer(reducedBy: 10),
          onPressed: () async {
            await controller.createOrder();
          },
        ),
      ],
    ),
  );
}

Widget _address(BuildContext context, ShoppingCardController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Card(
          elevation: 5,
          color: GalegosUiDefaut.colors['fundo'],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: .spaceBetween,
              crossAxisAlignment: .center,
              spacing: 10,
              runSpacing: 10,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: GalegosTextFormField(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabled: false,
                      label: controller.rua.value,
                      inputType: TextInputType.text,
                    ),
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.bairro.value,
                    inputType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.cidade.value,
                    inputType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.estado.value,
                    inputType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .auto,
                    enabled: true,
                    label: 'Número*',
                    focusNode: controller.numeroFocus,
                    inputType: .numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    maxLength: 6,
                    buildCounter:
                        (
                          context, {
                          required currentLength,
                          required isFocused,
                          required maxLength,
                        }) => SizedBox.shrink(),
                    maxLengthEnforcement: .enforced,
                    controller: controller.numeroEC,
                    validator: Validatorless.required('Número obrigatório'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: -3,
          top: -3,
          child: IconButton(
            onPressed: () {
              controller.closeCard();
            },
            icon: Icon(Icons.expand_less_outlined),
          ),
        ),
      ],
    ),
  );
}

String _total(ShoppingCardController controller) {
  final total = controller.totalPay(controller.taxa.value);
  return FormatterHelper.formatCurrency(total ?? 0);
}
