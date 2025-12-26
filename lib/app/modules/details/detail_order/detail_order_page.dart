import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/icons.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'detail_order_controller.dart';

class DetailOrderPage extends GetView<DetailOrderController> {
  const DetailOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.admin ? _adminPage(context, controller) : _clientPage(context, controller);
  }
}

EasyStep _buildCustomStep({
  required String title,
  required int index,
  required DetailOrderController controller,
  required ThemeData theme,
}) {
  return EasyStep(
    customStep: CircleAvatar(
      radius: 8,
      backgroundColor: controller.getStepIndex() >= index
          ? theme.colorScheme.tertiary
          : Colors.grey[300],
      child: CircleAvatar(
        radius: 7,
        backgroundColor: controller.getStepIndex() >= index
            ? theme.colorScheme.tertiary
            : Colors.grey[300],
      ),
    ),
    customTitle: Text(
      title,
      textAlign: .left,
      style: TextStyle(
        color: controller.getStepIndex() >= index ? theme.colorScheme.tertiary : Colors.grey[500],
      ),
    ),
  );
}

Widget _adminPage(BuildContext context, DetailOrderController controller) {
  final ThemeData theme = Theme.of(context);
  return Scaffold(
    appBar: GalegosAppBar(context: context),
    extendBodyBehindAppBar: true,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SafeArea(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Column(
              spacing: 8,
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Pedido: #${controller.order.id.hashCode.bitLength}',
                      style: theme.textTheme.headlineLarge,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: (controller.order.status == 'preparando')
                            ? AppColors.containerPreparing
                            : (controller.order.status == 'a caminho')
                            ? AppColors.containerOnTheWay
                            : AppColors.containerDelivered,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          controller.order.status.toUpperCase(),
                          style: (controller.order.status == 'preparando')
                              ? theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.preparing,
                                )
                              : (controller.order.status == 'a caminho')
                              ? theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.onTheWay,
                                )
                              : theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.delivered,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text('${controller.order.date}, ${controller.order.time}'),
              ],
            ),
          ),
          Center(
            child: Column(
              spacing: 20,
              children: [
                Card(
                  elevation: 0,
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Nome do cliente: ',
                            style: theme.textTheme.titleSmall,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              controller.order.userName,
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Text(
                        'Entrega em: ${controller.order.endereco.rua}, ${controller.order.endereco.numeroResidencia}',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Itens do Pedido:',
                            style: theme.textTheme.titleSmall,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Column(
                              spacing: 8,
                              children: controller.order.cart.map((pedido) {
                                return Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: [
                                        Text(
                                          '${pedido.item.quantidade}x',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                        Text(
                                          pedido.item.alimento?.name ??
                                              pedido.item.produto?.name ??
                                              '',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      FormatterHelper.formatCurrency(
                                        ((pedido.item.produto?.price ??
                                                pedido.item.alimento?.pricePerSize[pedido
                                                    .item
                                                    .tamanho] ??
                                                0.0) *
                                            pedido.item.quantidade),
                                      ),
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),

                          Divider(
                            color: AppColors.tertiary,
                          ),
                          Divider(
                            color: AppColors.tertiary,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Column(
                              spacing: 8,
                              children: [
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      FormatterHelper.formatCurrency(
                                        controller.order.amountToPay - controller.order.taxa,
                                      ),
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      'Taxa de entrega',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      FormatterHelper.formatCurrency(controller.order.taxa),
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: AppColors.tertiary,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  FormatterHelper.formatCurrency(controller.order.amountToPay),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Card(
                  elevation: 0,
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Informações de Pagamento',
                            style: theme.textTheme.titleSmall,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              spacing: 20,
                              children: [
                                Icon(
                                  controller.order.formaPagamento == 'Pix'
                                      ? Icons.qr_code_2
                                      : controller.order.formaPagamento == 'Cartão de Crédito' ||
                                            controller.order.formaPagamento == 'Cartão de Débito'
                                      ? Restaurante.credit_card
                                      : controller.order.formaPagamento == 'Vale Alimentação' ||
                                            controller.order.formaPagamento == 'Vale Refeição'
                                      ? Restaurante.ticket_alt
                                      : Restaurante.money_bill_wave,
                                  color: AppColors.title,
                                ),
                                Text(controller.order.formaPagamento),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}

Widget _clientPage(BuildContext context, DetailOrderController controller) {
  final ThemeData theme = Theme.of(context);
  return Scaffold(
    appBar: GalegosAppBar(context: context),
    extendBodyBehindAppBar: true,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SafeArea(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Column(
              spacing: 8,
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Pedido: #${controller.order.id.hashCode.bitLength}',
                      style: theme.textTheme.headlineLarge,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: (controller.order.status == 'preparando')
                            ? AppColors.containerPreparing
                            : (controller.order.status == 'a caminho')
                            ? AppColors.containerOnTheWay
                            : AppColors.containerDelivered,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          controller.order.status.toUpperCase(),
                          style: (controller.order.status == 'preparando')
                              ? theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.preparing,
                                )
                              : (controller.order.status == 'a caminho')
                              ? theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.onTheWay,
                                )
                              : theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.delivered,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text('${controller.order.date}, ${controller.order.time}'),
              ],
            ),
          ),
          Center(
            child: Column(
              spacing: 20,
              children: [
                Card(
                  elevation: 0,
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Text(
                        'Entrega em: ${controller.order.endereco.rua}, ${controller.order.endereco.numeroResidencia}',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Itens do Pedido:',
                            style: theme.textTheme.titleSmall,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Column(
                              spacing: 8,
                              children: controller.order.cart.map((pedido) {
                                return Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: [
                                        Text(
                                          '${pedido.item.quantidade}x',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                        Text(
                                          pedido.item.alimento?.name ??
                                              pedido.item.produto?.name ??
                                              '',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      FormatterHelper.formatCurrency(
                                        ((pedido.item.produto?.price ??
                                                pedido.item.alimento?.pricePerSize[pedido
                                                    .item
                                                    .tamanho] ??
                                                0.0) *
                                            pedido.item.quantidade),
                                      ),
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),

                          Divider(
                            color: AppColors.tertiary,
                          ),
                          Divider(
                            color: AppColors.tertiary,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Column(
                              spacing: 8,
                              children: [
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      FormatterHelper.formatCurrency(
                                        controller.order.amountToPay - controller.order.taxa,
                                      ),
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      'Taxa de entrega',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      FormatterHelper.formatCurrency(controller.order.taxa),
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: AppColors.tertiary,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  FormatterHelper.formatCurrency(controller.order.amountToPay),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Card(
                  elevation: 0,
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Informações de Pagamento',
                            style: theme.textTheme.titleSmall,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              spacing: 20,
                              children: [
                                Icon(
                                  controller.order.formaPagamento == 'Pix'
                                      ? Icons.qr_code_2
                                      : controller.order.formaPagamento == 'Cartão de Crédito' ||
                                            controller.order.formaPagamento == 'Cartão de Débito'
                                      ? Restaurante.credit_card
                                      : controller.order.formaPagamento == 'Vale Alimentação' ||
                                            controller.order.formaPagamento == 'Vale Refeição'
                                      ? Restaurante.ticket_alt
                                      : Restaurante.money_bill_wave,
                                  color: AppColors.title,
                                ),
                                Text(controller.order.formaPagamento),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Card(
                  elevation: 0,
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Rastreamento',
                            style: theme.textTheme.titleSmall,
                          ),
                          Align(
                            alignment: .centerLeft,
                            child: SizedBox(
                              width: context.widthTransformer(reducedBy: 80),
                              height: context.heightTransformer(reducedBy: 65),
                              child: EasyStepper(
                                showLoadingAnimation: false,
                                stepRadius: 10,
                                direction: .vertical,
                                internalPadding: 0,
                                padding: const EdgeInsets.only(left: 0),
                                lineStyle: LineStyle(
                                  lineType: LineType.dotted,
                                  lineThickness: 2,
                                  finishedLineColor: theme.colorScheme.tertiary,
                                  activeLineColor: theme.colorScheme.tertiary,
                                  unreachedLineColor: Colors.grey[300],
                                ),
                                alignment: .centerLeft,
                                finishedStepBackgroundColor: theme.colorScheme.tertiary,
                                finishedStepBorderColor: theme.colorScheme.tertiary,
                                activeStep: controller.getStepIndex(),
                                steps: [
                                  _buildCustomStep(
                                    title: 'Preparando',
                                    index: 0,
                                    controller: controller,
                                    theme: theme,
                                  ),
                                  _buildCustomStep(
                                    title: 'Saiu para entrega',
                                    index: 1,
                                    controller: controller,
                                    theme: theme,
                                  ),
                                  _buildCustomStep(
                                    title: 'Entregue',
                                    index: 3,
                                    controller: controller,
                                    theme: theme,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}
