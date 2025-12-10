import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/dialogs/alert_dialog_history.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_shimmer.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/modules/history/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Container(
                  width: context.widthTransformer(reducedBy: 10),
                  decoration: BoxDecoration(
                    color: GalegosUiDefaut.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Histórico de pedidos',
                        style: TextStyle(
                          color: GalegosUiDefaut.colors['fundo'],
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
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
                  return Center(child: Text('Erro ao carregar pedidos'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('Nenhum pedido encontrado', style: TextStyle(fontSize: 18)),
                  );
                }
                final docs = snapshot.data!.docs;
                final pedidos = docs.map((doc) {
                  final data = doc.data();
                  return PedidoModel.fromMap({...data, 'id': doc.id});
                }).toList();
                final Map<String, Map<String, List<PedidoModel>>> pedidosPorDataHora = {};
                for (var pedido in pedidos) {
                  final String data = pedido.date;
                  final String hora = pedido.time;
                  pedidosPorDataHora.putIfAbsent(data, () => {});
                  final Map<String, List<PedidoModel>> pedidosDoDia = pedidosPorDataHora[data]!;
                  pedidosDoDia.putIfAbsent(hora, () => []);
                  pedidosDoDia[hora]!.add(pedido);
                }
                return Column(
                  children: pedidosPorDataHora.entries.map((dataEntry) {
                    final data = dataEntry.key;
                    final pedidosAgrupadosPorHora = dataEntry.value;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                            child: Text(data, style: GalegosUiDefaut.theme.textTheme.titleLarge),
                          ),
                          ...pedidosAgrupadosPorHora.entries.map((horaEntry) {
                            final hora = horaEntry.key;
                            final listaDePedidosNaHora = horaEntry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    top: 10.0,
                                    bottom: 5.0,
                                  ),
                                  child: Text(
                                    'Pedido realizado às $hora',
                                    style: GalegosUiDefaut.theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ...listaDePedidosNaHora.map((pedido) {
                                  final nome = pedido.cart
                                      .map((e) => e.item.alimento?.name ?? e.item.produto?.name)
                                      .join(', ');
                                  final total = FormatterHelper.formatCurrency(pedido.amountToPay);
                                  return SizedBox(
                                    width: context.widthTransformer(reducedBy: 10),
                                    child: Card(
                                      elevation: 5,
                                      color: GalegosUiDefaut.colorScheme.secondary,
                                      child: InkWell(
                                        onTap: () {
                                          final carrinhoName = pedido.cart
                                              .map((item) {
                                                return item.item.alimento?.name ??
                                                    item.item.produto?.name ??
                                                    '';
                                              })
                                              .toList()
                                              .join(', ');
                                          final pedidoTipo = pedido.cart
                                              .map(
                                                (e) =>
                                                    e.item.produto != null ? 'Produto' : 'Marmita',
                                              )
                                              .toList()
                                              .join(', ');
                                          final cep = MaskCep();
                                          final valor = FormatterHelper.formatCurrency(
                                            pedido.amountToPay - pedido.taxa,
                                          );
                                          final taxa = FormatterHelper.formatCurrency(pedido.taxa);
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
                                              numeroResidencia: pedido.endereco.numeroResidencia
                                                  .toString(),
                                              bairro: pedido.endereco.bairro,
                                              cidade: pedido.endereco.cidade,
                                              estado: pedido.endereco.estado,
                                              cep: cep.maskText(pedido.endereco.cep),
                                              horarioInicio: pedido.time,
                                              horarioSairEntrega: pedido.timePath ?? '',
                                              horarioEntregue: pedido.timeFinished ?? '',
                                              data: pedido.date,
                                              onPressed: () {},
                                              statusPedido: pedido.status,
                                            ),
                                          );
                                        },
                                        splashColor: GalegosUiDefaut.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(8),
                                        child: ListTile(
                                          title: Text(
                                            'Carrinho: $nome',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: Text(total),
                                          subtitle: (pedido.status == 'preparando')
                                              ? Text(
                                                  pedido.status.toUpperCase(),
                                                  style: TextStyle(
                                                    color: GalegosUiDefaut.colorScheme.error,
                                                  ),
                                                )
                                              : (pedido.status == 'a caminho')
                                              ? Text(
                                                  pedido.status.toUpperCase(),
                                                  style: TextStyle(
                                                    color: Color(0xFFC97B3E),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  pedido.status.toUpperCase(),
                                                  style: TextStyle(color: Colors.green),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ).paddingOnly(bottom: 5);
                                }),
                              ],
                            );
                          }),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
