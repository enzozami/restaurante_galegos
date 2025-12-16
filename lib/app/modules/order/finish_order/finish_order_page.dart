import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/enum/payment_type.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_carrinho.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_valores.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/item_carrinho_model.dart';
import './finish_order_controller.dart';

class FinishOrderPage extends GetView<FinishOrderController> {
  const FinishOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentType payment = controller.args['payment'];

    return Scaffold(
      appBar: GalegosAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                child: Text('Revise seus Dados', style: GalegosUiDefaut.theme.textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 40),
                child: Text(
                  'Carrinho',
                  style: GalegosUiDefaut.theme.textTheme.titleSmall,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.args['itens'].length,
                      itemBuilder: (BuildContext context, int index) {
                        final CarrinhoModel p = controller.args['itens'][index];
                        return CardCarrinho(
                          title: p.item.nameDisplay,
                          description: p.item.subtitleDisplay,
                          price: p.item.priceDisplay,
                          quantity: p.item.quantidade.toString(),
                          isViewFinish: true,
                        );
                      },
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 40),
                child: Text(
                  'Endereço',
                  style: GalegosUiDefaut.theme.textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: .spaceAround,
                      crossAxisAlignment: .center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 22.0),
                          child: SizedBox(
                            width: context.widthTransformer(reducedBy: 10),
                            child: GalegosTextFormField(
                              floatingLabelBehavior: .always,
                              enabled: false,
                              label: 'CEP',
                              inputType: TextInputType.text,
                              controller: TextEditingController(
                                text: controller.args['cep'],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: context.widthTransformer(reducedBy: 10),
                          child: GalegosTextFormField(
                            floatingLabelBehavior: .always,
                            enabled: false,
                            label: 'Rua',
                            inputType: TextInputType.text,
                            controller: TextEditingController(text: controller.args['rua']),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: GalegosTextFormField(
                            floatingLabelBehavior: .always,
                            enabled: false,
                            label: 'Bairro',
                            inputType: TextInputType.text,
                            controller: TextEditingController(text: controller.args['bairro']),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: GalegosTextFormField(
                            floatingLabelBehavior: .always,
                            enabled: false,
                            label: 'Cidade',
                            inputType: TextInputType.text,
                            controller: TextEditingController(text: controller.args['cidade']),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: GalegosTextFormField(
                            floatingLabelBehavior: .always,
                            enabled: false,
                            label: 'Estado',
                            inputType: TextInputType.text,
                            controller: TextEditingController(text: controller.args['estado']),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: GalegosTextFormField(
                            floatingLabelBehavior: .auto,
                            enabled: false,
                            label: 'Número',
                            controller: TextEditingController(
                              text: controller.args['numero'].toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 40),
                child: Text(
                  'Forma de Pagamento',
                  style: GalegosUiDefaut.theme.textTheme.titleSmall,
                ),
              ),
              Center(
                child: RadioGroup(
                  groupValue: payment,
                  onChanged: (_) {},
                  child: Card(
                    elevation: 5,
                    color: GalegosUiDefaut.colorScheme.tertiary,
                    child: SizedBox(
                      width: context.widthTransformer(reducedBy: 10),
                      child: Column(
                        children: [
                          ListTile(
                            iconColor: GalegosUiDefaut.colorScheme.secondary,
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Row(
                              children: [
                                Icon(controller.getIconData()),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  controller.getNamePaymentType(),
                                  style: GalegosUiDefaut.textCard.titleSmall,
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Forma selecionada*',
                              style: GalegosUiDefaut.textCard.bodyMedium,
                            ),
                            leading: Radio<PaymentType>(value: payment),
                          ),
                          (controller.getType() != null)
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: GalegosUiDefaut.colorScheme.secondary,
                                  ),
                                  child: SizedBox(
                                    width: context.widthTransformer(reducedBy: 10),
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          (controller.args['payment'] == PaymentType.dinheiro)
                                              ? Text('Troco para: ')
                                              : SizedBox.shrink(),
                                          Text(
                                            controller.getType()!,
                                            style: GalegosUiDefaut.textCardPaymentType.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: GalegosUiDefaut.colorScheme.tertiary,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(child: CardValores(preco: controller.args['preco'], carrinho: false)),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: GalegosUiDefaut.colorScheme.tertiary,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GalegosButtonDefault(
                  label: 'FINALIZAR',
                  width: context.widthTransformer(reducedBy: 10),
                  onPressed: () async => await controller.createOrder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
