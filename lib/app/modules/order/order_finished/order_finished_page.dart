import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_history.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import './order_finished_controller.dart';

class OrderFinishedPage extends GetView<OrderFinishedController> {
  const OrderFinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller.scrollController,
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
                      'PEDIDOS ENTREGUES',
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
                child: StreamBuilder(
                  stream: controller.listOrders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data();
                        final pedido = PedidoModel.fromMap({...data, 'id': docs[index].id});

                        final nome = pedido.cart
                            .map((e) => e.item.alimento?.name ?? e.item.produto?.name)
                            .join(', ');

                        final total = FormatterHelper.formatCurrency(pedido.amountToPay);
                        return Card(
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
                                  .map((e) => e.item.produto != null ? 'Produto' : 'Marmita')
                                  .toList()
                                  .join(', ');

                              final cep = MaskCep();

                              final valor = FormatterHelper.formatCurrency(
                                pedido.amountToPay - pedido.taxa,
                              );
                              final taxa = FormatterHelper.formatCurrency(pedido.taxa);
                              final total = FormatterHelper.formatCurrency(pedido.amountToPay);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialogHistory(
                                  titleButton: 'Sair para entrega',
                                  isAdmin: true,
                                  pedidoLabel: pedidoTipo,
                                  carrinhoName: carrinhoName,
                                  valor: valor,
                                  taxa: taxa,
                                  total: total,
                                  nomeCliente: pedido.userName,
                                  rua: pedido.rua,
                                  numeroResidencia: pedido.numeroResidencia.toString(),
                                  bairro: pedido.bairro,
                                  cidade: pedido.cidade,
                                  estado: pedido.estado,
                                  cep: cep.maskText(pedido.cep),
                                  horarioInicio: pedido.time,
                                  horarioSairEntrega: pedido.timePath ?? '',
                                  horarioEntregue: pedido.timeFinished ?? '',
                                  data: pedido.date,
                                  onPressed: () async {
                                    // controller.orderFinished(pedido);
                                    Get.back();
                                  },
                                  statusPedido: 'Sair para entrega',
                                ),
                              );
                            },
                            splashColor: GalegosUiDefaut.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                            child: ListTile(
                              title: Text('Carrinho: $nome', overflow: TextOverflow.ellipsis),
                              trailing: Text(total),
                              // leading: Text('Pedido: ${e.id}'),
                              subtitle: Text('Status: ${pedido.status.toUpperCase()}'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
