import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_history.dart';
import './all_orders_controller.dart';

class AllOrdersPage extends GetView<AllOrdersController> {
  const AllOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: GalegosUiDefaut.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'PEDIDOS REALIZADOS',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: GalegosUiDefaut.colors['fundo'],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: Obx(() {
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: controller.listOrders.value.map((e) {
                      final carrinho = e.cart
                          .map((item) {
                            return item.item.alimento?.name ?? item.item.produto?.name ?? '';
                          })
                          .toList()
                          .join(', ');

                      final total = FormatterHelper.formatCurrency(e.amountToPay);
                      return Card(
                        elevation: 5,
                        color: GalegosUiDefaut.colorScheme.secondary,
                        child: InkWell(
                          onTap: () {
                            final carrinhoName = e.cart
                                .map((item) {
                                  return item.item.alimento?.name ?? item.item.produto?.name ?? '';
                                })
                                .toList()
                                .join(', ');

                            final pedidoTipo = e.cart
                                .map((e) => e.item.produto != null ? 'Produto' : 'Marmita')
                                .toList()
                                .join(', ');

                            final cep = MaskCep();

                            final valor = FormatterHelper.formatCurrency(e.amountToPay - e.taxa);
                            final taxa = FormatterHelper.formatCurrency(e.taxa);
                            final total = FormatterHelper.formatCurrency(e.amountToPay);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogHistory(
                                idPedido: e.id,
                                titleButton: 'Sair para entrega',
                                isAdmin: true,
                                pedidoLabel: pedidoTipo,
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
                                onPressed: () async {
                                  controller.orderFinished(e);
                                  Get.back();
                                },
                                statusPedido: 'Sair para entrega',
                              ),
                            );
                          },
                          splashColor: GalegosUiDefaut.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                          child: ListTile(
                            title: Text('Carrinho: $carrinho', overflow: TextOverflow.ellipsis),
                            trailing: Text(total),
                            leading: Text('Pedido: ${e.id}'),
                            subtitle: Text('Status: ${e.status.toUpperCase()}'),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
