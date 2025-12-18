import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:restaurante_galegos/app/core/enum/payment_type.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_valores.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/icons.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';

import '../../../core/ui/theme/app_colors.dart';
import './payment_controller.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: GalegosAppBar(
        context: context,
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                child: Text(
                  'Pagamento',
                  style: theme.textTheme.headlineLarge,
                ),
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
                      theme: theme,
                    ),
                    _cardPagamento(
                      context: context,
                      title: 'Vale (VA/VR)',
                      icon: Restaurante.ticket_alt,
                      subtitle: 'Alimentação ou Refeição',
                      type: PaymentType.vale,
                      controller: controller,
                      theme: theme,
                    ),
                    _cardPagamento(
                      context: context,
                      title: 'Dinheiro',
                      icon: Restaurante.money_bill_wave,
                      subtitle: 'Pagamento em espécie',
                      type: PaymentType.dinheiro,
                      controller: controller,
                      theme: theme,
                    ),
                    _cardPagamento(
                      context: context,
                      title: 'PIX',
                      icon: Icons.qr_code_2,
                      subtitle: '',
                      type: PaymentType.pix,
                      controller: controller,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              (controller.paymentType.value != PaymentType.nulo)
                  ? Column(
                      children: [
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: GalegosButtonDefault(
                            label: 'AVANÇAR',
                            width: context.widthTransformer(reducedBy: 10),
                            onPressed: () {
                              Get.toNamed(
                                '/order/finish',
                                arguments: controller.arguments(),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 50,
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
  required ThemeData theme,
}) {
  final isSelected = controller.paymentType.value == type;
  return RadioGroup(
    groupValue: controller.paymentType.value,
    onChanged: (value) => controller.changePaymentType(value as PaymentType),
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Card(
        elevation: 5,
        color: (isSelected) ? theme.colorScheme.tertiary : theme.colorScheme.secondary,
        child: GestureDetector(
          onTap: () => controller.changePaymentType(type),
          child: SizedBox(
            width: context.widthTransformer(reducedBy: 10),
            child: Column(
              children: [
                ListTile(
                  iconColor: (isSelected)
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.tertiary,
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
                            ? theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.secondary,
                              )
                            : theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    subtitle,
                    style: (isSelected)
                        ? theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.secondary,
                          )
                        : theme.textTheme.bodyMedium,
                  ),
                  leading: Radio<PaymentType>(value: type),
                ),
                if (isSelected)
                  (type == PaymentType.cartao)
                      ? Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              _cardType(
                                context: context,
                                title: 'Crédito',
                                subtitle: subtitle,
                                type: CardType.credito,
                                controller: controller,
                                theme: theme,
                              ),
                              _cardType(
                                context: context,
                                title: 'Débito',
                                subtitle: subtitle,
                                type: CardType.debito,
                                controller: controller,
                                theme: theme,
                              ),
                            ],
                          ),
                        )
                      : (type == PaymentType.vale)
                      ? Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              _cardVale(
                                context: context,
                                title: 'Alimentação',
                                subtitle: subtitle,
                                type: ValeType.alimentacao,
                                controller: controller,
                                theme: theme,
                              ),
                              _cardVale(
                                context: context,
                                title: 'Refeição',
                                subtitle: subtitle,
                                type: ValeType.refeicao,
                                controller: controller,
                                theme: theme,
                              ),
                            ],
                          ),
                        )
                      : (type == PaymentType.pix)
                      ? SizedBox.shrink()
                      : Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
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
  required ThemeData theme,
}) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: RadioGroup(
      groupValue: controller.cardType.value,
      onChanged: (value) => controller.changeCardType(value as CardType),
      child: GestureDetector(
        onTap: () => controller.changeCardType(type),
        child: SizedBox(
          width: context.widthTransformer(reducedBy: 10),
          child: ListTile(
            iconColor: theme.colorScheme.tertiary,
            title: Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
            leading: Radio<CardType>(value: type),
          ),
        ),
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
  required ThemeData theme,
}) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: RadioGroup(
      groupValue: controller.valeType.value,
      onChanged: (value) => controller.changeValeType(value as ValeType),
      child: GestureDetector(
        onTap: () => controller.changeValeType(type),
        child: SizedBox(
          width: context.widthTransformer(reducedBy: 10),
          child: ListTile(
            iconColor: theme.colorScheme.tertiary,
            title: Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
            leading: Radio<ValeType>(value: type),
          ),
        ),
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
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: Form(
      key: controller.formKey,
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          children: [
            GalegosTextFormField(
              floatingLabelBehavior: .auto,
              inputType: .number,
              // prefixText: 'R\$ ',
              controller: controller.trocoEC,
              // hintText: 'R\$ 0,00',
              maxLength: 11,
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) => SizedBox.shrink(),
              maxLengthEnforcement: .enforced,
              inputFormatter: [
                CurrencyTextInputFormatter.currency(
                  locale: 'pt_BR',
                  decimalDigits: 2,
                  symbol: 'R\$',
                ),
              ],
            ),
            Text(subtitle),
          ],
        ),
      ),
    ),
  );
}
