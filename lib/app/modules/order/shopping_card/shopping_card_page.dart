import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/widgets/list_shopping_card.dart';
import 'shopping_card_controller.dart';

class ShoppingCardPage extends GetView<ShoppingCardController> {
  const ShoppingCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var total = controller.totalPay();
    var label = FormatterHelper.formatCurrency(total ?? 0);
    var quantityItems = controller.products.fold<int>(0, (sum, e) => sum + e.quantity);

    return Scaffold(
      body: Visibility(
        visible: controller.products.isNotEmpty,
        replacement: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Nenhum item no carrinho!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
              child: Text(
                'Carrinho',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(
                maxHeight: context.heightTransformer(reducedBy: 40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListShoppingCard(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          label,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(' / $quantityItems itens'),
                      ],
                    ),
                    GalegosButtonDefault(
                      label: 'FINALIZAR',
                      width: context.widthTransformer(reducedBy: 60),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class AmounToPay extends GetView<ShoppingCardController> {
  const AmounToPay({super.key});

  @override
  Widget build(BuildContext context) {
    final total = controller.totalPay();
    return Text(FormatterHelper.formatCurrency(total ?? 0));
  }
}
