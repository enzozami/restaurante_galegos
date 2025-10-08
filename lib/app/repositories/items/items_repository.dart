import 'package:restaurante_galegos/app/models/item_model.dart';

abstract interface class ItemsRepository {
  Future<List<List<ItemModel>>> getItems();
}
