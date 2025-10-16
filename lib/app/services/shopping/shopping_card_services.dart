import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';
import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class ShoppingCardServices extends GetxService {
  final RxMap<int, ShoppingCardModel> _shoppingCard = <int, ShoppingCardModel>{}.obs;

  List<ShoppingCardModel> get productsSelected => _shoppingCard.values.toList();

  ShoppingCardModel? getById(int id) => _shoppingCard[id];

  double get amountToPay {
    double amount = 0;
    for (var item in _shoppingCard.values) {
      final productPrice = item.product?.price ?? 0.0;
      final priceFood = item.selectedPrice ?? 0.0;
      amount += productPrice + priceFood;
    }
    return amount;
  }

  void addOrUpdateProduct(ItemModel? itemModel, {required int quantity}) {
    if (itemModel == null) return;

    if (quantity == 0) {
      _shoppingCard.remove(itemModel.id);
    } else {
      _shoppingCard.update(
        itemModel.id,
        (item) {
          return item;
        },
        ifAbsent: () {
          return ShoppingCardModel(product: itemModel);
        },
      );
    }
  }

  void addOrUpdateFood(
    AlimentoModel? alimentoModel, {
    required int quantity,
    required String selectedSize,
  }) {
    if (alimentoModel == null) return;

    if (quantity == 0) {
      _shoppingCard.remove(alimentoModel.id);
    } else {
      final selectedPrice = alimentoModel.pricePerSize[selectedSize] ?? 0.0;

      _shoppingCard.update(
          alimentoModel.id,
          (food) => ShoppingCardModel(
                food: alimentoModel,
                selectSize: selectedSize,
                selectedPrice: selectedPrice,
              ),
          ifAbsent: () => ShoppingCardModel(
                food: alimentoModel,
                selectSize: selectedSize,
                selectedPrice: selectedPrice,
              ));
    }
  }
}
