import 'package:restaurante_galegos/app/models/item.dart';
import 'package:restaurante_galegos/app/repositories/items/items_repository.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';

import './items_services.dart';

class ItemsServicesImpl implements ItemsServices {
  final ItemsRepository _itemsRepository;

  ItemsServicesImpl(
      {required ItemsRepository itemsRepository, required ProductsRepository productsRepository})
      : _itemsRepository = itemsRepository;

  @override
  Future<List<Item>> getItems() => _itemsRepository.getItems();
}
