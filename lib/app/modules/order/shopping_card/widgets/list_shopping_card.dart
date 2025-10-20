import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
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
          var product = p.food ?? p.product;
          final foodName = p.food?.name ?? '';
          final itemName = p.product?.name ?? '';
          final sizeSelected = p.selectSize;

          final VoidCallback add = (product == p.food)
              ? () => controller.addQuantityFood(p)
              : () => controller.addQuantityProduct(p);

          final VoidCallback remove = (product == p.food)
              ? () => controller.removeQuantityFood(p)
              : () => controller.removeQuantityProduct(p);

          late String nameItem;
          if (foodName.isEmpty) {
            nameItem = itemName;
          } else {
            nameItem = foodName;
          }

          final priceFood = p.selectedPrice ?? 0.0;

          return Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    nameItem,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text((sizeSelected != null)
                      ? sizeSelected[0].toUpperCase() + sizeSelected.substring(1)
                      : sizeSelected ?? ''),
                  trailing: Text(
                    FormatterHelper.formatCurrency(p.product?.price ?? priceFood),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GalegosPlusMinus(
                color: Colors.black,
                addCallback: add,
                removeCallback: remove,
                quantityUnit: p.quantity,
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    });
  }
}
