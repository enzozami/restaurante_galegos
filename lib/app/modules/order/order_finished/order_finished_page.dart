import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_history.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_shimmer.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

import './order_finished_controller.dart';

class OrderFinishedPage extends GetView<OrderFinishedController> {
  const OrderFinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(
                  'Entregues',
                  style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              StreamBuilder(
                stream: controller.listOrders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: List.generate(
                          5,
                          (_) => CardShimmer(
                            height: 80,
                            width: double.infinity,
                          ).paddingOnly(bottom: 10),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        'Nenhum pedido encontrado',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data();
                      final pedido = PedidoModel.fromMap({
                        ...data,
                        'id': docs[index].id,
                      });

                      final carrinho = pedido.cart
                          .map(
                            (e) => e.item.alimento?.name ?? e.item.produto?.name,
                          )
                          .join('\n');

                      final total = FormatterHelper.formatCurrency(
                        pedido.amountToPay,
                      );
                      return CardHistory(
                        onTap: () {
                          // controller.onAdminOrderTapped(pedido);
                          Get.toNamed('/detail/orders', arguments: pedido);
                        },
                        id: pedido.id.hashCode.bitLength.toString(),
                        itens: carrinho,
                        price: total,
                        status: Text(''),
                        horario: pedido.time,
                        date: pedido.date,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
