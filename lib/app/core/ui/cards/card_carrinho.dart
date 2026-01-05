import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: theme.cardTheme.elevation,
        margin: EdgeInsets.zero,
        color: theme.cardTheme.color,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFFBE8462),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: .bold),
          ),
          subtitle: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                price,
                style: theme.textTheme.titleSmall,
              ),
              (isViewFinish)
                  ? Container(
                      margin: EdgeInsets.only(left: 25),
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
                      removeCallback: remove ?? () {},
                      quantityUnit: int.parse(quantity),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
