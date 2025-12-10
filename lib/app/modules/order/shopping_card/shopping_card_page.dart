import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_valores.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/widgets/list_shopping_card.dart';
import 'shopping_card_controller.dart';

class ShoppingCardPage extends StatefulWidget {
  const ShoppingCardPage({super.key});

  @override
  State<ShoppingCardPage> createState() => _ShoppingCardPageState();
}

class _ShoppingCardPageState extends GalegosState<ShoppingCardPage, ShoppingCardController> {
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.heightTransformer(reducedBy: 60)),
                  Center(
                    child: Text(
                      'Nenhum item no carrinho!',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Carrinho', style: GalegosUiDefaut.theme.textTheme.titleLarge),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: const Color.fromRGBO(177, 0, 0, 1)),
                        onPressed: () => controller.clear(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(padding: const EdgeInsets.all(8.0), child: ListShoppingCard()),
                ),
                const SizedBox(height: 30),
                Center(
                  child: CardValores(
                    preco: controller.totalPay() ?? 0,
                    carrinho: true,
                  ),
                ),
                const SizedBox(height: 30),
                Divider(),
                const SizedBox(height: 30),
                Center(
                  child: GalegosButtonDefault(
                    label: 'AVANÇAR',
                    width: context.widthTransformer(reducedBy: 10),
                    onPressed: () async {
                      Get.toNamed(
                        '/address',
                        arguments: controller.totalPay(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
