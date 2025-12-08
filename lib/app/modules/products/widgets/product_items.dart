import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_items.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

import '../../../core/ui/widgets/card_shimmer.dart';

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
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 30.0),
                child: Text(c.name, style: GalegosUiDefaut.theme.textTheme.titleLarge),
              ),
              Container(
                constraints: const BoxConstraints(minHeight: 100),
                width: context.width,
                child: controller.loading.value
                    ? Wrap(
                        alignment: .spaceAround,
                        children: List.generate(
                          10,
                          (_) => CardShimmer(height: 310, width: 180).paddingOnly(bottom: 8),
                        ),
                      )
                    : Wrap(
                        alignment: .spaceAround,
                        children: filtered
                            .map(
                              (e) => CardItems(
                                width: 190,
                                height: 310,
                                imageHeight: 130,
                                titulo: e.name,
                                preco: FormatterHelper.formatCurrency(e.price),
                                descricao: e.description,
                                image: (e.image.isNotEmpty) ? e.image : '',
                                onPressed: () => controller.onClientProductQuickAddPressed(e),
                                onTap: () => controller.onClientProductDetailsTapped(context, e),
                                styleTitle: GalegosUiDefaut.theme.textTheme.titleMedium,
                                styleDescricao: GalegosUiDefaut.theme.textTheme.bodyLarge,
                                stylePreco: GalegosUiDefaut.textProduct.titleMedium,
                                isProduct: true,
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

class _ProductsAdmin extends StatefulWidget {
  @override
  State<_ProductsAdmin> createState() => _ProductsAdminState();
}

class _ProductsAdminState extends GalegosState<_ProductsAdmin, ProductsController> {
  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 16.0),
                child: Text(c.name, style: GalegosUiDefaut.theme.textTheme.titleLarge),
              ),
              Container(
                constraints: const BoxConstraints(minHeight: 100),
                width: context.width,
                child: Column(
                  children: filtered
                      .map(
                        (e) => Card(
                          elevation: 2,
                          color: GalegosUiDefaut.theme.cardTheme.color,
                          clipBehavior: .hardEdge,
                          child: Dismissible(
                            background: Container(
                              color: GalegosUiDefaut.colorScheme.error,
                              alignment: .centerRight,
                              padding: EdgeInsets.all(15),
                              child: Icon(Icons.delete, color: Colors.white),
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
                              splashColor: GalegosUiDefaut.theme.splashColor,
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                controller.onAdminProductUpdateDetailsTapped(context, e);
                              },
                              child: ListTile(
                                textColor: Colors.black87,
                                leading: e.temHoje
                                    ? Text('Ativo', style: TextStyle(color: Colors.green))
                                    : Text(
                                        'Inativo',
                                        style: TextStyle(color: GalegosUiDefaut.colorScheme.error),
                                      ),
                                title: Text(
                                  e.name,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
