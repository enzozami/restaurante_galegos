import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
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
  final _cepEC = TextEditingController();
  final _numeroEC = TextEditingController();

  final _cepFormatter = MaskCep();

  @override
  void dispose() {
    super.dispose();
    _cepEC.dispose();
    _numeroEC.dispose();
  }

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
                  SizedBox(
                    height: context.heightTransformer(reducedBy: 60),
                  ),
                  Center(
                    child: Text(
                      'Nenhum item no carrinho!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
                      Text(
                        'Carrinho',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => controller.clear(),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: context.heightTransformer(reducedBy: 50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListShoppingCard(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Spacer(),
                Divider(),
                Form(
                  key: _formKey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() {
                        var total = controller.totalPay();
                        var label = FormatterHelper.formatCurrency(total ?? 0);
                        var quantityItems = controller.products.fold<int>(
                          0,
                          (sum, e) => sum + e.item.quantidade,
                        );

                        return Column(
                          children: [
                            GalegosTextFormField(
                              icon: IconButton(
                                  onPressed: () {
                                    controller.getCep(
                                      address: int.parse(
                                        _cepFormatter.getUnmaskedText(),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.search)),
                              inputType: TextInputType.numberWithOptions(decimal: true),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              label: 'CEP',
                              mask: _cepFormatter,
                              controller: _cepEC,
                              validator: Validatorless.required('CEP obrigatório'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Visibility(
                              visible: (_cepEC.text.length >= 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    SizedBox(
                                      width: context.widthTransformer(reducedBy: 10),
                                      child: GalegosTextFormField(
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        enabled: false,
                                        label: controller.rua.value,
                                        inputType: TextInputType.text,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: GalegosTextFormField(
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        enabled: false,
                                        label: controller.bairro.value,
                                        inputType: TextInputType.text,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: GalegosTextFormField(
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        enabled: false,
                                        label: controller.cidade.value,
                                        inputType: TextInputType.text,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: GalegosTextFormField(
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        enabled: false,
                                        label: controller.estado.value,
                                        inputType: TextInputType.text,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: GalegosTextFormField(
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        enabled: true,
                                        label: 'Número*',
                                        inputType: TextInputType.number,
                                        controller: _numeroEC,
                                        validator: Validatorless.required('Número obrigatório'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      label,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    Text(' / itens'),
                                  ],
                                ),
                                GalegosButtonDefault(
                                  label: 'FINALIZAR',
                                  width: context.widthTransformer(reducedBy: 60),
                                  onPressed: () async {
                                    final formValid = _formKey.currentState?.validate() ?? false;
                                    if (formValid) {
                                      controller.quantityRx(quantityItems);
                                      final cepSemMask = _cepFormatter.getUnmaskedText();
                                      final success = await controller.createOrder(
                                          address: cepSemMask, numero: _numeroEC.text);
                                      if (success) {
                                        Get.snackbar(
                                          'Pedido feito com sucesso',
                                          'Seu pedido foi enviado com sucesso, enviaremos para você o quanto antes!',
                                          duration: 3.seconds,
                                          backgroundColor: Colors.amberAccent,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class AmounToPay extends GetView<ShoppingCardController> {
  const AmounToPay({super.key});

  @override
  Widget build(BuildContext context) {
    final total = controller.totalPay();
    return Text(FormatterHelper.formatCurrency(total ?? 0));
  }
}
