import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_carrinho.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/item_carrinho_model.dart';
import './finish_order_controller.dart';

class FinishOrderPage extends GetView<FinishOrderController> {
  const FinishOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('${controller.args}'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.args['itens'].length,
                  itemBuilder: (BuildContext context, int index) {
                    final CarrinhoModel p = controller.args['itens'][index];
                    return CardCarrinho(
                      title: p.item.nameDisplay,
                      description: p.item.subtitleDisplay,
                      price: p.item.priceDisplay,
                      quantity: p.item.quantidade.toString(),
                      isViewFinish: true,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
