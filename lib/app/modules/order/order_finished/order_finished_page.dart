import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/models/order_finished_model.dart';
import './order_finished_controller.dart';

class OrderFinishedPage extends GetView<OrderFinishedController> {
  const OrderFinishedPage({super.key});

  void _showDialog(BuildContext context, OrderFinishedModel finished) {
    final carrinhoName = finished.pedido.cart
        .map((item) {
          return item.item.alimento?.name ?? item.item.produto?.name ?? '';
        })
        .toList()
        .join(', ');

    final pedidoTipo = finished.pedido.cart
        .map((e) => e.item.produto != null ? 'Produto' : 'Marmita')
        .toList()
        .join(', ');

    final cep = MaskCep();

    final valor =
        FormatterHelper.formatCurrency(finished.pedido.amountToPay - finished.pedido.taxa);
    final taxa = FormatterHelper.formatCurrency(finished.pedido.taxa);
    final total = FormatterHelper.formatCurrency(finished.pedido.amountToPay);
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
                    'Nome: ${finished.pedido.userName}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    finished.pedido.cpfOrCnpj,
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
                    'Detalhes:',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    finished.pedido.date,
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Hora do pedido: ${finished.pedido.time}h'),
                  Text('Hora final: ${finished.pedido.timeFinished}'),
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
                    'Rua: ${finished.pedido.rua}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Número: ${finished.pedido.numeroResidencia}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Bairro: ${finished.pedido.bairro}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Cidade: ${finished.pedido.cidade}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Estado: ${finished.pedido.estado}',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'CEP: ${cep.maskText(finished.pedido.cep)}',
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
            ElevatedButton(
              onPressed: () {
                Get.close(0);
              },
              child: Text('FECHAR'),
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
                    'PEDIDOS FINALIZADOS',
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
                            _showDialog(context, e);
                          },
                          splashColor: Colors.amber,
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
