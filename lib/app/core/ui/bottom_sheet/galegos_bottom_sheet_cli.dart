import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';

class GalegosBottomSheetCli extends StatelessWidget {
  final bool admin;

  final String image;
  final String nameItem;
  final String description;
  final String price;
  final Widget plusMinus;
  final VoidCallback onPressed;

  const GalegosBottomSheetCli({
    super.key,
    required this.admin,
    required this.image,
    required this.nameItem,
    required this.description,
    required this.price,
    required this.plusMinus,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return admin
        ? _adminBottomSheet(context)
        : _clientBottomSheet(
            context,
            onPressed,
            image: image,
            nameItem: nameItem,
            description: description,
            price: price,
            plusMinus: plusMinus,
          );
  }
}

Widget _clientBottomSheet(
  BuildContext context,
  VoidCallback onPressed, {
  required String image,
  required String nameItem,
  required String description,
  required String price,
  required Widget plusMinus,
}) {
  final ThemeData theme = Theme.of(context);
  return SingleChildScrollView(
    child: Container(
      clipBehavior: Clip.antiAlias,
      height: Get.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.tertiary, // Garante que a cor acompanhe o Container
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        spacing: 30,
        crossAxisAlignment: .start,
        children: [
          (image.isNotEmpty && image != '')
              ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: Get.width,
                  height: Get.height * 0.35,
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              nameItem,
              style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.secondary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 20),
            child: Text(
              description,
              textAlign: .justify,
              style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.secondary),
            ),
          ),
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              Text(
                price,
                style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.primary),
              ),
              plusMinus,
            ],
          ),
          Center(
            child: GalegosButtonDefault(
              label: 'ADICIONAR NO CARRINHO',
              width: context.widthTransformer(reducedBy: 10),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _adminBottomSheet(BuildContext context) {
  return Container(
    decoration: BoxDecoration(),
    child: Column(
      children: [],
    ),
  );
}
