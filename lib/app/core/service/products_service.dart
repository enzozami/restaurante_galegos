import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';

class ProductsService extends GetxService {
  final ProductsServices _itemsServices;
  final items = <ProductModel>[].obs;

  Future<ProductsService> init() async {
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

  Future<void> refreshItens() async {
    final data = await _itemsServices.getProducts();
    items.assignAll(data);
  }
}
