import 'package:restaurante_galegos/app/models/item.dart';

abstract interface class ItemsRepository {
  Future<List<Item>> getItems();
  Future<void> updateTemHoje(int id, Item item, bool novoValor);
}
