import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';
import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class ShoppingCardServices extends GetxService {
  final RxMap<String, ShoppingCardModel> _shoppingCard = <String, ShoppingCardModel>{}.obs;

  String _getProductKey(ItemModel item) => 'P_${item.id}';
  String _getFoodKey(AlimentoModel alimento, String selectedSize) =>
      'F_${alimento.id}_$selectedSize';

  List<ShoppingCardModel> get productsSelected => _shoppingCard.values.toList();
  // ShoppingCardModel? getProductQuantity()

  ShoppingCardModel? getByKey(String key) => _shoppingCard[key];

  double get amountToPay {
    double amount = 0;
    for (var item in _shoppingCard.values) {
      final productPrice = item.product?.price ?? 0.0;
      final priceFood = item.selectedPrice ?? 0.0;
      amount += (productPrice + priceFood) * item.quantity;
    }
    return amount;
  }

  void addOrUpdateProduct(
    ItemModel? itemModel, {
    required int quantity,
  }) {
    if (itemModel == null) return;

    final key = _getProductKey(itemModel);

    if (quantity == 0) {
      _shoppingCard.remove(key);
    } else {
      _shoppingCard.update(
        key,
        (item) => ShoppingCardModel(
          quantity: quantity,
          product: itemModel,
        ),
        ifAbsent: () {
          return ShoppingCardModel(
            quantity: quantity,
            product: itemModel,
          );
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

    final key = _getFoodKey(alimentoModel, selectedSize);

    if (quantity == 0) {
      _shoppingCard.remove(key);
    } else {
      final selectedPrice = alimentoModel.pricePerSize[selectedSize] ?? 0.0;

      _shoppingCard.update(
        key,
        (food) => ShoppingCardModel(
          quantity: quantity,
          food: alimentoModel,
          selectSize: selectedSize,
          selectedPrice: selectedPrice,
        ),
        ifAbsent: () => ShoppingCardModel(
          quantity: quantity,
          food: alimentoModel,
          selectSize: selectedSize,
          selectedPrice: selectedPrice,
        ),
      );
    }
  }

  void clear() => _shoppingCard.clear();
}
