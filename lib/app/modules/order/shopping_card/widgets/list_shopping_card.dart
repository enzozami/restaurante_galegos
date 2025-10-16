import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_controller.dart';

class ListShoppingCard extends GetView<ShoppingCardController> {
  const ListShoppingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.products.toList();
      return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final p = products[index];

          final foodName = p.food?.name ?? '';
          final productName = p.product?.name ?? '';
          return ListTile(
            title: Text(
              foodName.isNotEmpty ? foodName : productName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Quantidade: ${p.quantity}'),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: products.length,
      );
    });
  }
}
