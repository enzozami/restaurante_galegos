import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/item.dart';
import 'package:restaurante_galegos/app/services/items/items_services.dart';

class ProductsService extends GetxService {
  final ItemsServices _itemsServices;
  final items = <Item>[].obs;

  Future<ProductsService> init() async {
    await refreshItens();
    return this;
  }

  ProductsService({
    required ItemsServices itemsServices,
  }) : _itemsServices = itemsServices;

  Future<void> updateTemHoje(int id, Item item) async {
    final novoValor = !item.temHoje;
    await _itemsServices.updateTemHoje(id, item, novoValor);

    final index = items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      items[index] = items[index].copyWith(temHoje: novoValor);
      items.refresh();
    }
  }

  Future<void> refreshItens() async {
    final data = await _itemsServices.getItems();
    items.assignAll(data);
  }
}
