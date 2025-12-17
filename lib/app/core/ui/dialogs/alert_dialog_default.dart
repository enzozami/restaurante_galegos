import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';

class AlertDialogDefault extends StatelessWidget {
  final ProductModel? item;
  final FoodModel? alimento;
  final VoidCallback onPressed;
  final Widget? plusMinus;
  final bool visible;

  const AlertDialogDefault({
    super.key,
    this.item,
    this.alimento,
    required this.onPressed,
    this.plusMinus,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        item?.name ?? alimento?.name ?? '',
        textAlign: .center,
        style: theme.textTheme.titleSmall,
        // style: TextStyle(
        //   color: GalegosUiDefaut.colorScheme.primary,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
      icon: IconButton(
        icon: Icon(Icons.close, color: theme.colorScheme.secondary),
        alignment: .centerRight,
        onPressed: () => Get.back(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item?.description ?? alimento?.description ?? '',
            textAlign: .justify,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: .center,
            children: [plusMinus ?? SizedBox.shrink()],
          ),
        ],
      ),
      actions: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              'Adicionar',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
