import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';
import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class ShoppingServices extends GetxService {
  final _shoppingCard = <int, ShoppingCardModel>{};

  List<ShoppingCardModel> get items => _shoppingCard.values.toList();

  ShoppingCardModel? getById(int id) => _shoppingCard[id];

  void addAndRemoveItemInShoppingCard(
    ItemModel? itemModel, {
    required int quantity,
  }) {
    if (quantity == 0) {
      _shoppingCard.remove(itemModel?.id);
    } else {
      _shoppingCard.update(
        itemModel!.id,
        (item) {
          item.quantity = quantity;
          return item;
        },
        ifAbsent: () {
          return ShoppingCardModel(
            quantity: quantity,
            product: itemModel,
          );
        },
      );
    }
  }

  void addAndRemoveFoodInShoppingCard(
    AlimentoModel? alimentoModel, {
    required int quantity,
  }) {
    if (quantity == 0) {
      _shoppingCard.remove(alimentoModel?.id);
    } else {
      _shoppingCard.update(
        alimentoModel!.id,
        (alimento) {
          alimento.quantity = quantity;
          return alimento;
        },
        ifAbsent: () {
          return ShoppingCardModel(
            quantity: quantity,
            food: alimentoModel,
          );
        },
      );
    }
  }
}
