import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';

class CardCarrinho extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String quantity;
  final bool isViewFinish;
  final VoidCallback? add;
  final VoidCallback? remove;

  const CardCarrinho({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.isViewFinish,
    this.add,
    this.remove,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: Card(
        elevation: theme.cardTheme.elevation,
        color: theme.cardTheme.color,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 190, 132, 98),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    title,
                    style: theme.textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    description,
                    style: theme.textTheme.bodyLarge,
                  ),
                  trailing: Text(
                    price,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ),
              (isViewFinish)
                  ? Container(
                      margin: EdgeInsets.only(left: 40),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Qtd: $quantity',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : GalegosPlusMinus(
                      color: Colors.black,
                      addCallback: add ?? () {},
                      //() => controller.adicionarQuantidadeCarrinho(p),
                      removeCallback: remove ?? () {},
                      // () => controller.removerQuantidadeCarrinho(p),
                      quantityUnit: int.parse(quantity),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
