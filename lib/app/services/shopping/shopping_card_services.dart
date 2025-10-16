import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';
import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class ShoppingCardServices extends GetxService {
  final RxMap<int, ShoppingCardModel> _shoppingCard = <int, ShoppingCardModel>{}.obs;

  List<ShoppingCardModel> get productsSelected => _shoppingCard.values.toList();

  ShoppingCardModel? getById(int id) => _shoppingCard[id];

  void addOrUpdateProduct(ItemModel? itemModel, {required int quantity}) {
    if (itemModel == null) return;

    if (quantity == 0) {
      _shoppingCard.remove(itemModel.id);
    } else {
      _shoppingCard.update(
        itemModel.id,
        (item) {
          item.quantity = quantity;
          return item;
        },
        ifAbsent: () {
          return ShoppingCardModel(quantity: quantity, product: itemModel);
        },
      );
    }
  }

  void addOrUpdateFood(AlimentoModel? alimentoModel, {required int quantity}) {
    if (alimentoModel == null) return;

    if (quantity == 0) {
      _shoppingCard.remove(alimentoModel.id);
    } else {
      _shoppingCard.update(
        alimentoModel.id,
        (food) {
          food.quantity = quantity;
          return food;
        },
        ifAbsent: () {
          return ShoppingCardModel(quantity: quantity, food: alimentoModel);
        },
      );
    }
  }
}
