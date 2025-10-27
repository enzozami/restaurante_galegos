import 'package:restaurante_galegos/app/models/teste/item.dart';

abstract interface class ItemsRepository {
  Future<List<Item>> getItems();
}
