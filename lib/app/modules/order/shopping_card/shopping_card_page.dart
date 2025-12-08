import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
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
  final _formKey = GlobalKey<FormState>();
  late FocusNode _numeroFocus;
  final _cepFormatter = MaskCep();

  @override
  void initState() {
    super.initState();
    _numeroFocus = FocusNode();
  }

  @override
  void dispose() {
    _numeroFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          final totalItems = FormatterHelper.formatCurrency(controller.totalPay(0) ?? 0);
          final totalTaxa = FormatterHelper.formatCurrency(controller.taxa.value);

          var total = controller.totalPay(controller.taxa.value);
          var label = FormatterHelper.formatCurrency(total ?? 0);
          var quantityItems = controller.products.fold<int>(0, (sum, e) => sum + e.item.quantidade);
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
                  key: _formKey,
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
                              inputType: TextInputType.numberWithOptions(decimal: true),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              label: 'CEP',
                              prefixIcon: Icon(Icons.location_on),
                              onEditingComplete:
                                  controller.cepEC.text.isNotEmpty &&
                                      controller.cepInput.value.length == 9
                                  ? () {
                                      controller.getCep(
                                        address: _cepFormatter.getUnmaskedText(),
                                        numeroFocus: _numeroFocus,
                                      );
                                      controller.isOpen.value = true;
                                    }
                                  : null,
                              mask: _cepFormatter,
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
                                  visible:
                                      (controller.cepEC.text.isNotEmpty &&
                                      controller.cepEC.text != '' &&
                                      controller.cep.value != '' &&
                                      controller.cepInput.value.length == 9 &&
                                      controller.cepInput.value == controller.cep.value),
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
                                        onPressed:
                                            controller.cepEC.text.isNotEmpty &&
                                                controller.cepInput.value.length == 9
                                            ? () {
                                                controller.getCep(
                                                  address: _cepFormatter.getUnmaskedText(),
                                                  numeroFocus: _numeroFocus,
                                                );
                                                controller.isOpen.value = true;
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                  child: Visibility(
                                    visible:
                                        (controller.isOpen.value == true &&
                                        controller.cepInput.value.length == 9 &&
                                        controller.cepInput.value == controller.cep.value),
                                    replacement: IconButton(
                                      onPressed: () {
                                        controller.closeCard();
                                      },
                                      icon: Align(
                                        alignment: Alignment.center,
                                        child: Icon(Icons.expand_more),
                                      ),
                                    ),
                                    child: _AddressCard(
                                      controller: controller,
                                      focusNodeNumero: _numeroFocus,
                                    ),
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
                              : _FinishedOrder(
                                  controller: controller,
                                  totalItems: totalItems,
                                  totalTaxa: totalTaxa,
                                  label: label,
                                  formKey: _formKey,
                                  quantityItems: quantityItems,
                                  cepFormatter: _cepFormatter,
                                ),
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

class _FinishedOrder extends StatelessWidget {
  const _FinishedOrder({
    required this.controller,
    required this.totalItems,
    required this.totalTaxa,
    required this.label,
    required GlobalKey<FormState> formKey,
    required this.quantityItems,
    required MaskCep cepFormatter,
  }) : _formKey = formKey,
       _cepFormatter = cepFormatter;

  final ShoppingCardController controller;
  final String totalItems;
  final String totalTaxa;
  final String label;
  final GlobalKey<FormState> _formKey;
  final int quantityItems;
  final MaskCep _cepFormatter;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible:
          (controller.cepEC.text.isNotEmpty &&
          controller.cepEC.text != '' &&
          controller.cep.value != '' &&
          controller.cepEC.text.length == 9 &&
          controller.cepInput.value == controller.cep.value),
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
                    'Total dos itens: $totalItems',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Taxa de entrega: $totalTaxa',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Total a pagar: $label',
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
              final formValid = _formKey.currentState?.validate() ?? false;
              if (formValid) {
                controller.quantityRx(quantityItems);
                final cepSemMask = _cepFormatter.getUnmaskedText();
                final success = await controller.createOrder(
                  address: cepSemMask,
                  numero: controller.numeroEC.text,
                );
                if (success) {
                  Get.snackbar(
                    'Pedido feito com sucesso',
                    'Seu pedido foi enviado com sucesso, enviaremos para você o quanto antes!',
                    duration: 3.seconds,
                    backgroundColor: GalegosUiDefaut.colorScheme.primary,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.controller, required this.focusNodeNumero});

  final ShoppingCardController controller;
  final FocusNode focusNodeNumero;

  @override
  Widget build(BuildContext context) {
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
                      focusNode: focusNodeNumero,
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
}

class AmounToPay extends GetView<ShoppingCardController> {
  const AmounToPay({super.key});

  @override
  Widget build(BuildContext context) {
    final total = controller.totalPay(controller.taxa.value);
    return Text(FormatterHelper.formatCurrency(total ?? 0));
  }
}
