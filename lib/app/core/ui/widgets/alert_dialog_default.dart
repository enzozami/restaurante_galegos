import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/item.dart';

class AlertDialogDefault extends StatelessWidget {
  final Item? item;
  final FoodModel? alimento;
  final VoidCallback onPressed;
  final VoidCallback onPressedR;
  final Widget? plusMinus;
  final bool visible;

  const AlertDialogDefault({
    super.key,
    this.item,
    this.alimento,
    required this.onPressed,
    this.plusMinus,
    required this.visible,
    required this.onPressedR,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GalegosUiDefaut.colorScheme.onPrimary,
      titlePadding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      actionsPadding: const EdgeInsets.all(20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              item?.name ?? alimento?.name ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: GalegosUiDefaut.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: GalegosUiDefaut.colorScheme.secondary),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item?.description ?? alimento?.description ?? '',
            style: TextStyle(
              color: GalegosUiDefaut.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              plusMinus ?? SizedBox.shrink(),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: visible,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GalegosUiDefaut.colorScheme.primary,
                  // minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onPressedR,
                child: Text(
                  'Remover',
                  style: TextStyle(
                    color: GalegosUiDefaut.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GalegosUiDefaut.colorScheme.primary,
                  // minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onPressed,
                child: Text(
                  'Adicionar',
                  style: TextStyle(
                    color: GalegosUiDefaut.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
