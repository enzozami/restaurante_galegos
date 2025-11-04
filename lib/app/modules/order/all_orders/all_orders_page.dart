import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import './all_orders_controller.dart';

class AllOrdersPage extends GetView<AllOrdersController> {
  const AllOrdersPage({super.key});

  void _showDialog(BuildContext context, PedidoModel pedido) {
    final carrinhoName = pedido.cart
        .map((item) {
          return item.item.alimento?.name ?? item.item.produto?.name ?? '';
        })
        .toList()
        .join(', ');

    final pedidoTipo =
        pedido.cart.map((e) => e.item.produto != null ? 'Produto' : 'Marmita').toList().join(', ');

    final cep = MaskCep();

    final valor = FormatterHelper.formatCurrency(pedido.amountToPay - pedido.taxa);
    final taxa = FormatterHelper.formatCurrency(pedido.taxa);
    final total = FormatterHelper.formatCurrency(pedido.amountToPay);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          titlePadding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: const EdgeInsets.all(20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Pedido: $pedidoTipo',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dados:',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Nome: ${pedido.userName}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    pedido.cpfOrCnpj,
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Text(
                    'Descrição:',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    carrinhoName,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Text(
                    'Endereço:',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rua: ${pedido.rua}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Número: ${pedido.numeroResidencia}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Bairro: ${pedido.bairro}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Cidade: ${pedido.cidade}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Estado: ${pedido.estado}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'CEP: ${cep.maskText(pedido.cep)}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Text(
                    'Total dos itens: $valor',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Taxa de entrega: $taxa',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Valor final: $total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.close(0);
                  },
                  child: Text('FECHAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.orderFinished(pedido);
                    Get.close(0);
                  },
                  child: Text('FINALIZAR PEDIDO'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

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
                color: Colors.amber,
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
                    children: controller.listOrders.value.map((e) {
                      final carrinho = e.cart
                          .map((item) {
                            return item.item.alimento?.name ?? item.item.produto?.name ?? '';
                          })
                          .toList()
                          .join(', ');

                      final total = FormatterHelper.formatCurrency(e.amountToPay);
                      // final status = 'Status: ${e.status.toUpperCase()}';

                      return Card(
                        elevation: 5,
                        color: GalegosUiDefaut.theme.primaryColor,
                        child: InkWell(
                          onTap: () {
                            _showDialog(
                              context,
                              e,
                            );
                          },
                          splashColor: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                          child: ListTile(
                            title: Text(
                              'Carrinho: $carrinho',
                              overflow: TextOverflow.ellipsis,
                            ),
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
