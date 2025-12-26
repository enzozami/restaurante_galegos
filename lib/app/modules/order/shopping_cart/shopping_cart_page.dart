import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_carrinho.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_valores.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/models/item_carrinho_model.dart';

import 'shopping_cart_controller.dart';

class ShoppingCartPage extends GetView<ShoppingCartController> {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          return Visibility(
            visible: controller.products.isNotEmpty,
            replacement: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  SizedBox(height: context.heightTransformer(reducedBy: 60)),
                  Center(
                    child: Text(
                      'Nenhum item no carrinho!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 15,
              children: [
                SizedBox(
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 40, right: 15),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Carrinho',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: const Color.fromRGBO(177, 0, 0, 1),
                        ),
                        onPressed: () => controller.clear(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: controller.products.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final p = controller.products[index];

                        return CardCarrinho(
                          title: p.item.nameDisplay,
                          description: p.item.subtitleDisplay,
                          price: p.item.priceDisplay,
                          quantity: p.item.quantidade.toString(),
                          isViewFinish: false,
                          add: () => controller.adicionarQuantidadeCarrinho(p),
                          remove: () => controller.removerQuantidadeCarrinho(p),
                        );
                      },
                    );
                  }),
                ),
                Center(
                  child: CardValores(
                    preco: controller.totalPay() ?? 0,
                    carrinho: true,
                  ),
                ),
                Divider(),
                Center(
                  child: GalegosButtonDefault(
                    label: 'AVANÇAR',
                    width: context.widthTransformer(reducedBy: 10),
                    onPressed: () async {
                      Get.toNamed(
                        '/address',
                        arguments: controller.args(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
