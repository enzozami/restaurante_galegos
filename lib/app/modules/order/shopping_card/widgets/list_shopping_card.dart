import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/item_carrinho_model.dart';
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

          return Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    p.item.nameDisplay,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(p.item.subtitleDisplay),
                  trailing: Text(
                    p.item.priceDisplay,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GalegosPlusMinus(
                color: Colors.black,
                addCallback: () => controller.adicionarQuantidadeCarrinho(p),
                removeCallback: () => controller.removerQuantidadeCarrinho(p),
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
