import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_controller.dart';

class ListShoppingCard extends GetView<ShoppingCardController> {
  const ListShoppingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = controller.cart;
      return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final c = cart[index];

          final foodName = c.food?.name ?? '';
          final productName = c.product?.name ?? '';

          return Visibility(
            visible: foodName.isNotEmpty || productName.isNotEmpty,
            child: ListTile(
              title: Column(
                children: [
                  if (foodName.isNotEmpty) Text(foodName),
                  if (productName.isNotEmpty) Text(productName),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: cart.length,
      );
    });
  }
}
