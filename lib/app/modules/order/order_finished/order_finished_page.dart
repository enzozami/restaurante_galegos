import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_adm_history.dart';
import './order_finished_controller.dart';

class OrderFinishedPage extends GetView<OrderFinishedController> {
  const OrderFinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: GalegosUiDefaut.colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    'PEDIDOS ENTREGUES',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: Obx(() {
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: controller.listOrder.map((e) {
                      final carrinho = e.pedido.cart
                          .map((item) => item.item.alimento?.name ?? item.item.produto?.name ?? '')
                          .toList()
                          .join(', ');

                      final total = FormatterHelper.formatCurrency(e.pedido.amountToPay);
                      return Card(
                        color: GalegosUiDefaut.theme.primaryColor,
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            final carrinhoName = e.pedido.cart
                                .map((item) {
                                  return item.item.alimento?.name ?? item.item.produto?.name ?? '';
                                })
                                .toList()
                                .join(', ');

                            final pedidoTipo = e.pedido.cart
                                .map((e) => e.item.produto != null ? 'Produto' : 'Marmita')
                                .toList()
                                .join(', ');

                            final cep = MaskCep();

                            final valor = FormatterHelper.formatCurrency(
                                e.pedido.amountToPay - e.pedido.taxa);
                            final taxa = FormatterHelper.formatCurrency(e.pedido.taxa);
                            final total = FormatterHelper.formatCurrency(e.pedido.amountToPay);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialogAdmHistory(
                                    pedidoLabel: pedidoTipo,
                                    carrinhoName: carrinhoName,
                                    valor: valor,
                                    taxa: taxa,
                                    total: total,
                                    nomeCliente: e.pedido.userName,
                                    cpfOrCnpj: e.pedido.cpfOrCnpj,
                                    rua: e.pedido.rua,
                                    numeroResidencia: e.pedido.numeroResidencia.toString(),
                                    bairro: e.pedido.bairro,
                                    cidade: e.pedido.cidade,
                                    estado: e.pedido.estado,
                                    cep: cep.maskText(e.pedido.cep),
                                    horarioInicio: e.pedido.time,
                                    horarioSairEntrega: e.pedido.timePath ?? '',
                                    horarioEntregue: e.pedido.timeFinished ?? '',
                                    data: e.pedido.date,
                                    onPressed: () {
                                      Get.close(0);
                                    },
                                    statusPedido: 'Fechar',
                                  );
                                });
                          },
                          splashColor: GalegosUiDefaut.theme.splashColor,
                          borderRadius: BorderRadius.circular(8),
                          child: ListTile(
                            title: Text('Carrinho: $carrinho'),
                            trailing: Text(total),
                            leading: Text('Pedido ${e.pedido.id}'),
                            subtitle: Text(e.pedido.status.toUpperCase()),
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
