import 'package:restaurante_galegos/app/models/teste/item.dart';

abstract interface class ItemsServices {
  Future<List<Item>> getItems();
}
