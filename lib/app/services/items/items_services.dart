import 'package:restaurante_galegos/app/models/item.dart';

abstract interface class ItemsServices {
  Future<List<Item>> getItems();
}
