import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_history.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_shimmer.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/modules/history/history_controller.dart';

import '../../core/masks/mask_cep.dart';
import '../../core/ui/dialogs/alert_dialog_history.dart';
import '../../core/ui/theme/app_colors.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .start,
          children: [
            SafeArea(child: Container()),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 15, bottom: 15),
              child: Text(
                'Histórico',
                style: theme.textTheme.headlineLarge,
              ),
            ),
            StreamBuilder(
              stream: controller.allOrders,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: List.generate(
                      10,
                      (_) =>
                          CardShimmer(
                            height: 80,
                            width: context.width,
                          ).paddingOnly(
                            bottom: 10,
                            left: 20.0,
                            right: 20.0,
                            top: 10.0,
                          ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  // Se tiver erro - _message
                  return const Center(child: Text('Erro ao carregar pedidos'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // Se nao tiver nenhum pedido - text
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Nenhum pedido encontrado.'),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;
                final pedidos = docs
                    .map(
                      (doc) => PedidoModel.fromMap({...doc.data(), 'id': doc.id}),
                    )
                    .toList();
                final Map<String, List<PedidoModel>> pedidosPorData = {};

                pedidos.sort((a, b) {
                  String dataA = a.date.split('/').reversed.join();
                  String dataB = b.date.split('/').reversed.join();
                  int comparacao = dataB.compareTo(dataA);

                  if (comparacao != 0) {
                    return comparacao;
                  }

                  return b.time.compareTo(a.time);
                });

                for (var pedido in pedidos) {
                  pedidosPorData.putIfAbsent(pedido.date, () => []);
                  pedidosPorData[pedido.date]!.add(pedido);
                }

                return Column(
                  children: pedidosPorData.entries.map(
                    (pedido) {
                      final data = pedido.key;
                      final listaDePedidosDoDia = pedido.value;
                      return Center(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            ...listaDePedidosDoDia.map((pedido) {
                              final itens = pedido.cart
                                  .map(
                                    (p) => p.item.alimento?.name ?? p.item.produto?.name,
                                  )
                                  .join('\n');

                              return CardHistory(
                                date: data,
                                id: pedido.id.hashCode.toString(),
                                itens: itens,
                                price: FormatterHelper.formatCurrency(
                                  pedido.amountToPay,
                                ),
                                horario: pedido.time,
                                status: Container(
                                  decoration: BoxDecoration(
                                    color: (pedido.status == 'preparando')
                                        ? AppColors.containerPreparing
                                        : (pedido.status == 'a caminho')
                                        ? AppColors.containerOnTheWay
                                        : AppColors.containerDelivered,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      pedido.status.toUpperCase(),
                                      style: (pedido.status == 'preparando')
                                          ? theme.textTheme.labelSmall?.copyWith(
                                              color: AppColors.preparing,
                                            )
                                          : (pedido.status == 'a caminho')
                                          ? theme.textTheme.labelSmall?.copyWith(
                                              color: AppColors.onTheWay,
                                            )
                                          : theme.textTheme.labelSmall?.copyWith(
                                              color: AppColors.delivered,
                                            ),
                                    ),
                                  ),
                                ),

                                onTap: () {
                                  final carrinhoName = pedido.cart
                                      .map(
                                        (item) =>
                                            item.item.alimento?.name ??
                                            item.item.produto?.name ??
                                            '',
                                      )
                                      .where(
                                        (name) => name.isNotEmpty,
                                      )
                                      .toList()
                                      .join('\n');
                                  final pedidoTipo = pedido.cart
                                      .map(
                                        (e) => e.item.produto != null ? 'Produto' : 'Marmita',
                                      )
                                      .toList()
                                      .join(', ');
                                  final cep = MaskCep();
                                  final valor = FormatterHelper.formatCurrency(
                                    pedido.amountToPay - pedido.taxa,
                                  );
                                  final taxa = FormatterHelper.formatCurrency(
                                    pedido.taxa,
                                  );
                                  final totalFormatado = FormatterHelper.formatCurrency(
                                    pedido.amountToPay,
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogHistory(
                                      titleButton: 'Fechar',
                                      isAdmin: false,
                                      pedidoLabel: pedidoTipo,
                                      carrinhoName: carrinhoName,
                                      valor: valor,
                                      taxa: taxa,
                                      total: totalFormatado,
                                      nomeCliente: pedido.userName,
                                      rua: pedido.endereco.rua,
                                      numeroResidencia: pedido.endereco.numeroResidencia.toString(),
                                      bairro: pedido.endereco.bairro,
                                      cidade: pedido.endereco.cidade,
                                      estado: pedido.endereco.estado,
                                      cep: cep.maskText(
                                        pedido.endereco.cep,
                                      ),
                                      horarioInicio: pedido.time,
                                      horarioSairEntrega: pedido.timePath ?? '',
                                      horarioEntregue: pedido.timeFinished ?? '',
                                      data: pedido.date,
                                      onPressed: () {},
                                      statusPedido: pedido.status,
                                      pagamento: pedido.formaPagamento,
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
