import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/enum/payment_type.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/icons.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_valores.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import './payment_controller.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                child: Text('Pagamento', style: GalegosUiDefaut.theme.textTheme.titleLarge),
              ),
              Center(
                child: Column(
                  spacing: 15,
                  children: [
                    CardValores(
                      preco: controller.args['preco'],
                      taxa: controller.args['taxa'],
                      carrinho: false,
                    ),
                    _cardPagamento(
                      context: context,
                      title: 'Cartão',
                      icon: Restaurante.credit_card,
                      subtitle: 'Crédito ou Débito',
                      type: PaymentType.cartao,
                      controller: controller,
                    ),
                    _cardPagamento(
                      context: context,
                      title: 'Vale (VA/VR)',
                      icon: Restaurante.ticket_alt,
                      subtitle: 'Alimentação ou Refeição',
                      type: PaymentType.vale,
                      controller: controller,
                    ),
                    _cardPagamento(
                      context: context,
                      title: 'Dinheiro',
                      icon: Restaurante.money_bill_wave,
                      subtitle: 'Pagamento em espécie',
                      type: PaymentType.dinheiro,
                      controller: controller,
                    ),
                    _cardPagamento(
                      context: context,
                      title: 'PIX',
                      icon: Icons.qr_code_2,
                      subtitle: '',
                      type: PaymentType.pix,
                      controller: controller,
                    ),
                  ],
                ),
              ),
              Divider(),
              Center(
                child: GalegosButtonDefault(
                  label: 'AVANÇAR',
                  width: context.widthTransformer(reducedBy: 10),
                  onPressed: () {
                    Get.toNamed('/order/finish', arguments: controller.arguments());
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

Widget _cardPagamento({
  required BuildContext context,
  required String title,
  required IconData icon,
  required String subtitle,
  required PaymentType type,
  required PaymentController controller,
}) {
  final isSelected = controller.paymentType.value == type;
  return RadioGroup(
    groupValue: controller.paymentType.value,
    onChanged: (value) => controller.changePaymentType(value as PaymentType),
    child: Card(
      elevation: 5,
      color: (isSelected)
          ? GalegosUiDefaut.colorScheme.tertiary
          : GalegosUiDefaut.colorScheme.secondary,
      child: SizedBox(
        width: context.widthTransformer(reducedBy: 10),
        child: Column(
          children: [
            ListTile(
              iconColor: (isSelected)
                  ? GalegosUiDefaut.colorScheme.secondary
                  : GalegosUiDefaut.colorScheme.tertiary,
              contentPadding: const EdgeInsets.all(8.0),
              title: Row(
                children: [
                  Icon(icon),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    title,
                    style: (isSelected)
                        ? GalegosUiDefaut.textCard.titleSmall
                        : GalegosUiDefaut.theme.textTheme.titleSmall,
                  ),
                ],
              ),
              subtitle: Text(
                subtitle,
                style: (isSelected)
                    ? GalegosUiDefaut.textCard.bodyMedium
                    : GalegosUiDefaut.theme.textTheme.bodyMedium,
              ),
              leading: Radio<PaymentType>(value: type),
            ),
            if (isSelected)
              (type == PaymentType.cartao)
                  ? Container(
                      decoration: BoxDecoration(
                        color: GalegosUiDefaut.colorScheme.secondary,
                      ),
                      child: Column(
                        children: [
                          _cardType(
                            context: context,
                            title: 'Crédito',
                            subtitle: subtitle,
                            type: CardType.credito,
                            controller: controller,
                          ),
                          _cardType(
                            context: context,
                            title: 'Débito',
                            subtitle: subtitle,
                            type: CardType.debito,
                            controller: controller,
                          ),
                        ],
                      ),
                    )
                  : (type == PaymentType.vale)
                  ? Container(
                      decoration: BoxDecoration(
                        color: GalegosUiDefaut.colorScheme.secondary,
                      ),
                      child: Column(
                        children: [
                          _cardVale(
                            context: context,
                            title: 'Alimentação',
                            subtitle: subtitle,
                            type: ValeType.alimentacao,
                            controller: controller,
                          ),
                          _cardVale(
                            context: context,
                            title: 'Refeição',
                            subtitle: subtitle,
                            type: ValeType.refeicao,
                            controller: controller,
                          ),
                        ],
                      ),
                    )
                  : (type == PaymentType.pix)
                  ? SizedBox.shrink()
                  : Container(
                      decoration: BoxDecoration(
                        color: GalegosUiDefaut.colorScheme.secondary,
                      ),
                      child: _cardDinheiro(
                        context: context,
                        controller: controller,
                        title: 'Troco para quanto?',
                        subtitle: 'Deixe vazio se não precisar de troco',
                      ),
                    ),
          ],
        ),
      ),
    ),
  );
}

Widget _cardType({
  required BuildContext context,
  required String title,
  required String subtitle,
  required CardType type,
  required PaymentController controller,
}) {
  return RadioGroup(
    groupValue: controller.cardType.value,
    onChanged: (value) => controller.changeCardType(value as CardType),
    child: SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: ListTile(
        iconColor: GalegosUiDefaut.colorScheme.tertiary,
        title: Text(
          title,
          style: GalegosUiDefaut.theme.textTheme.bodyMedium,
        ),
        leading: Radio<CardType>(value: type),
      ),
    ),
  );
}

Widget _cardVale({
  required BuildContext context,
  required String title,
  required String subtitle,
  required ValeType type,
  required PaymentController controller,
}) {
  return RadioGroup(
    groupValue: controller.valeType.value,
    onChanged: (value) => controller.changeValeType(value as ValeType),
    child: SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: ListTile(
        iconColor: GalegosUiDefaut.colorScheme.tertiary,
        title: Text(
          title,
          style: GalegosUiDefaut.theme.textTheme.bodyMedium,
        ),
        leading: Radio<ValeType>(value: type),
      ),
    ),
  );
}

Widget _cardDinheiro({
  required BuildContext context,
  required PaymentController controller,
  required String title,
  required String subtitle,
}) {
  return Form(
    key: controller.formKey,
    child: ListTile(
      title: Text(title),
      subtitle: Column(
        children: [
          GalegosTextFormField(
            floatingLabelBehavior: .auto,
            inputType: .number,
            prefixText: 'R\$ ',
            controller: controller.trocoEC,
            // hintText: 'R\$ 0,00',
          ),
          Text(subtitle),
        ],
      ),
    ),
  );
}
