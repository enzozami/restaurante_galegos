import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/enum/payment_type.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/icons.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_valores.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
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
                    CardValores(preco: 15, taxa: 15, carrinho: false),
                    _cardPagamento(
                      context: context,
                      title: 'Cartão',
                      icon: Restaurante.credit_card,
                      subtitle: 'Crédito ou Débito',
                      type: PaymentType.credito,
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
                  ],
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
  return RadioGroup(
    groupValue: controller.paymentType.value,
    onChanged: (value) => controller.changePaymentType(value as PaymentType),
    child: Card(
      elevation: 5,
      color: GalegosUiDefaut.colorScheme.secondary,
      child: SizedBox(
        width: context.widthTransformer(reducedBy: 10),
        child: ListTile(
          iconColor: GalegosUiDefaut.colorScheme.tertiary,
          contentPadding: const EdgeInsets.all(8.0),
          title: Row(
            children: [
              Icon(icon),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: GalegosUiDefaut.theme.textTheme.titleSmall,
              ),
            ],
          ),
          subtitle: Text(
            subtitle,
            style: GalegosUiDefaut.theme.textTheme.bodyMedium,
          ),
          leading: Radio<PaymentType>(value: type),
        ),
      ),
    ),
  );
}
