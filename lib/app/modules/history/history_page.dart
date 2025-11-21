import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_history.dart';
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
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
            Obx(() {
              final inverso = controller.history.reversed.toList();

              final pedidos = <String, List<PedidoModel>>{};

              for (var pedido in inverso) {
                pedidos.putIfAbsent(pedido.date, () => []);
                pedidos[pedido.date]!.add(pedido);
              }
              return Column(
                spacing: 20,
                children: pedidos.entries.map((e) {
                  final data = e.key;
                  final pedidosDoDia = e.value;

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                          child: Text(data, style: GalegosUiDefaut.theme.textTheme.titleMedium),
                        ),
                        ...pedidosDoDia.map((e) {
                          final carrinho = e.cart
                              .map((item) {
                                return item.item.alimento?.name ?? item.item.produto?.name ?? '';
                              })
                              .toList()
                              .join(', ');

                          final total = FormatterHelper.formatCurrency(e.amountToPay);
                          return SizedBox(
                            width: context.widthTransformer(reducedBy: 10),
                            child: Card(
                              elevation: 5,
                              color: GalegosUiDefaut.colorScheme.secondary,
                              // color: GalegosUiDefaut.colors['fundo'],
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 190, 132, 98),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final cep = MaskCep();
                                      final valor = FormatterHelper.formatCurrency(
                                        e.amountToPay - e.taxa,
                                      );
                                      final taxa = FormatterHelper.formatCurrency(e.taxa);

                                      return AlertDialogHistory(
                                        isAdmin: false,
                                        pedidoLabel: e.id.toString(),
                                        idPedido: e.id,
                                        carrinhoName: carrinho,
                                        valor: valor,
                                        taxa: taxa,
                                        total: total,
                                        nomeCliente: e.userName,
                                        cpfOrCnpj: e.cpfOrCnpj,
                                        rua: e.rua,
                                        numeroResidencia: e.numeroResidencia.toString(),
                                        bairro: e.bairro,
                                        cidade: e.cidade,
                                        estado: e.estado,
                                        cep: cep.maskText(e.cep),
                                        horarioInicio: e.time,
                                        horarioSairEntrega: e.timePath ?? '',
                                        horarioEntregue: e.timeFinished ?? '',
                                        data: e.date,
                                        onPressed: () {},
                                        statusPedido: e.status,
                                      );
                                    },
                                  );
                                },
                                splashColor: GalegosUiDefaut.theme.splashColor,
                                borderRadius: BorderRadius.circular(8),
                                child: ListTile(
                                  title: Text(carrinho, overflow: TextOverflow.ellipsis),
                                  // subtitle: Text('Itens no carrinho: ${e.cart.length}'),
                                  trailing: Text('Total: $total'),
                                  subtitle: (e.status == 'preparando')
                                      ? Text(
                                          e.status.toUpperCase(),
                                          style: TextStyle(
                                            color: GalegosUiDefaut.colorScheme.error,
                                          ),
                                        )
                                      : (e.status == 'a caminho')
                                      ? Text(
                                          e.status.toUpperCase(),
                                          style: TextStyle(
                                            color: Color(0xFFC97B3E),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          e.status.toUpperCase(),
                                          style: TextStyle(color: Colors.green),
                                        ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
