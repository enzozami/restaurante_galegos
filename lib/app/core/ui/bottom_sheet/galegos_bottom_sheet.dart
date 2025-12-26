import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

class GalegosBottomSheet extends StatelessWidget {
  final bool admin;
  final VoidCallback onPressed;

  final String? image;
  final String? nameItem;
  final String? description;
  final String? price;
  final Widget? plusMinus;

  final PedidoModel? pedido;
  final String? titleButton;

  const GalegosBottomSheet({
    super.key,
    required this.admin,
    this.image,
    this.nameItem,
    this.description,
    this.price,
    this.plusMinus,
    required this.onPressed,
    this.pedido,
    this.titleButton,
  });

  @override
  Widget build(BuildContext context) {
    return admin
        ? _adminBottomSheet(
            titleButton: titleButton ?? '',
            context: context,
            pedido: pedido,
            onPressed: () {},
          )
        : _clientBottomSheet(
            context,
            onPressed,
            image: image ?? '',
            nameItem: nameItem ?? '',
            description: description ?? '',
            price: price ?? '',
            plusMinus: plusMinus ?? SizedBox.shrink(),
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

Widget _adminBottomSheet({
  required BuildContext context,
  required PedidoModel? pedido,
  required VoidCallback onPressed,
  required String titleButton,
}) {
  final ThemeData theme = Theme.of(context);
  return SingleChildScrollView(
    child: Container(
      clipBehavior: Clip.antiAlias,
      height: Get.height * 0.55,
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        spacing: 30,
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 25),
            child: Text(
              'Pedido: #${pedido?.id.hashCode.bitLength}',
              style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.secondary),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              width: context.widthTransformer(reducedBy: 10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: .start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Text(
                      'Itens do Pedido:',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    child: Column(
                      spacing: 8,
                      mainAxisAlignment: .start,
                      children: (pedido != null)
                          ? pedido.cart.map((pedido) {
                              return Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Text(
                                            '${pedido.item.quantidade}x',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: AppColors.title,
                                            ),
                                          ),
                                          Text(
                                            pedido.item.alimento?.name ??
                                                pedido.item.produto?.name ??
                                                '',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: AppColors.title,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${FormatterHelper.formatCurrency(pedido.item.produto?.price ?? pedido.item.alimento?.pricePerSize[pedido.item.tamanho] ?? 0)} cada',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: AppColors.title,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    FormatterHelper.formatCurrency(
                                      ((pedido.item.produto?.price ??
                                              pedido.item.alimento?.pricePerSize[pedido
                                                  .item
                                                  .tamanho] ??
                                              0.0) *
                                          pedido.item.quantidade),
                                    ),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.title,
                                    ),
                                  ),
                                ],
                              );
                            }).toList()
                          : List.empty(),
                    ),
                  ),

                  Divider(
                    color: AppColors.tertiary,
                  ),

                  (pedido != null)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          child: Column(
                            spacing: 8,
                            children: [
                              Row(
                                crossAxisAlignment: .start,
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.title,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    FormatterHelper.formatCurrency(
                                      pedido.amountToPay - pedido.taxa,
                                    ),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.title,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Align(
            alignment: .bottomCenter,
            child: GalegosButtonDefault(
              label: titleButton,
              width: context.widthTransformer(reducedBy: 10),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    ),
  );
}
