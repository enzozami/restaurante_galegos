import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_history.dart';
import 'package:restaurante_galegos/app/modules/history/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                width: context.widthTransformer(reducedBy: 10),
                decoration: BoxDecoration(
                  color: GalegosUiDefaut.colorScheme.primary,
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
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: Obx(() {
                  final inverso = controller.history.reversed.toList();
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: inverso.length,
                    itemBuilder: (context, index) {
                      final e = inverso[index];
                      final carrinho = e.cart
                          .map((item) {
                            return item.item.alimento?.name ?? item.item.produto?.name ?? '';
                          })
                          .toList()
                          .join(', ');

                      final total = FormatterHelper.formatCurrency(e.amountToPay);

                      return Card(
                        elevation: 5,
                        color: GalegosUiDefaut.theme.primaryColor,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final carrinhoName = e.cart
                                    .map((item) {
                                      return item.item.alimento?.name ??
                                          item.item.produto?.name ??
                                          '';
                                    })
                                    .toList()
                                    .join(', ');

                                final cep = MaskCep();

                                final valor =
                                    FormatterHelper.formatCurrency(e.amountToPay - e.taxa);
                                final taxa = FormatterHelper.formatCurrency(e.taxa);
                                final total = FormatterHelper.formatCurrency(e.amountToPay);

                                return AlertDialogHistory(
                                  pedidoLabel: e.id.toString(),
                                  carrinhoName: carrinhoName,
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
                            title: Text(
                              carrinho,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // subtitle: Text('Itens no carrinho: ${e.cart.length}'),
                            subtitle: Text(e.status.toUpperCase()),
                            leading: Text(e.date),
                            trailing: Text('Total: $total'),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
