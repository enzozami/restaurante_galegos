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
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final p = controller.products[index];
          var product = p.item.alimento ?? p.item.produto;
          final foodName = p.item.alimento?.name ?? '';
          final itemName = p.item.produto?.name ?? '';
          final sizeSelected = p.item.tamanho ?? '';

          final VoidCallback add = (product == p.item.alimento)
              ? () => controller.addQuantityFood(p)
              : () => controller.addQuantityProduct(p);

          final VoidCallback remove = (product == p.item.alimento)
              ? () => controller.removeQuantityFood(p)
              : () => controller.removeQuantityProduct(p);

          late String nameItem;
          if (foodName.isEmpty) {
            nameItem = itemName;
          } else {
            nameItem = foodName;
          }

          final priceFood = p.item.valorPorTamanho ?? 0.0;

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
                  subtitle: Text(
                    (sizeSelected != '')
                        ? sizeSelected[0].toUpperCase() + sizeSelected.substring(1)
                        : 'Produto',
                  ),
                  trailing: Text(
                    FormatterHelper.formatCurrency(p.item.produto?.price ?? priceFood),
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
                quantityUnit: p.item.quantidade,
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
