import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';

class ProductsService extends GetxService {
  final ProductsServices _itemsServices;
  final items = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;

  Future<ProductsService> init() async {
    await refreshCategories();
    await refreshItens();
    return this;
  }

  ProductsService({
    required ProductsServices itemsServices,
  }) : _itemsServices = itemsServices;

  Future<void> updateTemHoje(int id, ProductModel item) async {
    final novoValor = !item.temHoje;
    await _itemsServices.updateTemHoje(id, item, novoValor);

    final index = items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      items[index] = items[index].copyWith(temHoje: novoValor);
      items.refresh();
    }
  }

  Future<void> refreshCategories() async {
    final categoriesData = await _itemsServices.getCategories();
    categories.assignAll(categoriesData);
  }

  Future<void> refreshItens() async {
    final data = await _itemsServices.getProducts();
    log('DATA = SERVICE = ${data.map((e) => e.name)} - DATA - QUANT = ${data.length}');
    items.assignAll(data);
  }
}
