import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_items.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/text_shimmer.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

import '../../../core/ui/cards/card_shimmer.dart';

class ProductItems extends GetView<ProductsController> {
  const ProductItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: controller.admin ? _ProductsAdmin() : _ProductsClient(),
    );
  }
}

class _ProductsClient extends GetView<ProductsController> {
  const _ProductsClient();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      return Column(
        crossAxisAlignment: .start,
        children: controller.category.map((c) {
          final List<ProductModel> filtered = controller.getFilteredProducts(c);
          if (filtered.isEmpty) return SizedBox.shrink();
          return Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              controller.loading.value
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 10.0,
                        left: 30.0,
                      ),
                      child: Column(
                        children: List.generate(
                          1,
                          (index) => TextShimmer(width: 200, lines: 1),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 10.0,
                        left: 30.0,
                      ),
                      child: Text(
                        c.name,
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
              Container(
                constraints: const BoxConstraints(minHeight: 100),
                width: context.width,
                child: controller.loading.value
                    ? Wrap(
                        alignment: .spaceAround,
                        children: List.generate(
                          10,
                          (_) => CardShimmer(
                            height: 277,
                            width: 180,
                          ).paddingOnly(bottom: 8),
                        ),
                      )
                    : Wrap(
                        alignment: .spaceAround,
                        children: filtered
                            .map(
                              (e) => CardItems(
                                id: e.id,
                                // width: 175,
                                width: context.widthTransformer(reducedBy: 55),
                                height: 280,
                                imageHeight: 130,
                                titulo: e.name,
                                preco: FormatterHelper.formatCurrency(e.price),
                                descricao: e.description,
                                image: (e.image.isNotEmpty) ? e.image : '',
                                onPressed: () => controller.onClientProductQuickAddPressed(e),
                                onTap: () => controller.onClientProductDetailsTapped(context, e),
                                styleTitle: theme.textTheme.titleMedium,
                                styleDescricao: theme.textTheme.bodyLarge,
                                stylePreco: theme.textTheme.titleMedium,
                                isProduct: true,
                                isSelected: controller.itemSelect.value?.id == e.id,
                                onTapDown: (_) => controller.handlePress(e.id),
                                isPressed: controller.pressingItemId,
                                onTapUp: (_) => controller.handlePress(null),
                                onTapCancel: () => controller.handlePress(null),
                              ),
                            )
                            .toList(),
                      ),
              ),

              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      );
    });
  }
}

class _ProductsAdmin extends GetView<ProductsController> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      final category = controller.category;

      return Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: category.map((c) {
          final List<ProductModel> filtered = controller.getFilteredProducts(c);

          if (filtered.isEmpty) return SizedBox.shrink();

          return Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 10.0,
                  left: 16.0,
                ),
                child: controller.loading.value
                    ? SizedBox(
                        child: TextShimmer(
                          width: 200,
                          lines: 1,
                        ),
                      )
                    : Text(
                        c.name,
                        style: theme.textTheme.titleLarge,
                      ),
              ),
              Container(
                constraints: const BoxConstraints(minHeight: 100),
                width: context.width,
                child: controller.loading.value
                    ? Column(
                        children: List.generate(
                          20,
                          (_) => CardShimmer(
                            height: 90,
                            width: context.width,
                          ).paddingOnly(bottom: 8),
                        ),
                      )
                    : Column(
                        children: filtered
                            .map(
                              (e) => Card(
                                elevation: 2,
                                color: theme.cardTheme.color,
                                clipBehavior: .hardEdge,
                                child: Dismissible(
                                  background: Container(
                                    color: theme.colorScheme.error,
                                    alignment: .centerRight,
                                    padding: EdgeInsets.all(15),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  key: ValueKey(e.id),
                                  confirmDismiss: (_) async {
                                    return await controller.exibirConfirmacaoDescarte(context, e);
                                  },
                                  onDismissed: (_) async {
                                    controller.apagarProduto(e);
                                    await controller.refreshProducts();
                                  },
                                  child: InkWell(
                                    splashColor: theme.splashColor,
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      controller.onAdminProductUpdateDetailsTapped(
                                        context,
                                        e,
                                      );
                                    },
                                    child: ListTile(
                                      textColor: Colors.black87,
                                      leading: e.temHoje
                                          ? Text(
                                              'Ativo',
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            )
                                          : Text(
                                              'Inativo',
                                              style: TextStyle(
                                                color: theme.colorScheme.error,
                                              ),
                                            ),
                                      title: Text(
                                        e.name,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text(
                                        e.description ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Icon(Icons.edit_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
              const SizedBox(height: 45),
            ],
          );
        }).toList(),
      );
    });
  }
}
