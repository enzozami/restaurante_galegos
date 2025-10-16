import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_controller.dart';

class ListShoppingCard extends GetView<ShoppingCardController> {
  const ListShoppingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        itemCount: controller.products.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final p = controller.products[index];
          final foodName = p.food?.name ?? '';
          final itemName = p.product?.name ?? '';

          late String nameItem;
          if (foodName.isEmpty) {
            nameItem = itemName;
          } else {
            nameItem = foodName;
          }
          return ListTile(
            title: Text(nameItem),
            subtitle: Text('Quantidade ${p.quantity}'),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    });
  }
}
