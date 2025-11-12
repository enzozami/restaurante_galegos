import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/models/item_carrinho_model.dart';

class CarrinhoServices extends GetxService {
  final carrinho = <int, CarrinhoModel>{}.obs;

  RxList<CarrinhoModel> get itensCarrinho => carrinho.values.toList().obs;

  double? get amountToPay {
    var total = 0.0;
    for (var item in carrinho.values) {
      if (item.item.produto != null) {
        total += item.item.quantidade * (item.item.produto?.price ?? 0);
      }
      if (item.item.alimento != null) {
        total += item.item.quantidade * (item.item.valorPorTamanho ?? 0);
      }
    }
    return total;
  }

  CarrinhoModel? getById(int id) => carrinho[id];

  int get totalProducts => carrinho.length;

  void addOrUpdateProduct(ProductModel selected, {required int quantity}) {
    if (quantity == 0) {
      carrinho.remove(selected.id);
      return;
    } else {
      carrinho.update(selected.id, (item) {
        return CarrinhoModel(item: item.item.copyWith(quantidade: quantity));
      }, ifAbsent: () {
        return CarrinhoModel(
          item: ItemCarrinhoModel(
            quantidade: quantity,
            produto: selected,
          ),
        );
      });
    }
  }

  void addOrUpdateFood(FoodModel selected, {required int quantity, required String selectedSize}) {
    if (quantity == 0) {
      carrinho.remove(selected.id);
      return;
    } else {
      final selectedPrice = selected.pricePerSize[selectedSize];

      carrinho.update(
        selected.id,
        (item) {
          return CarrinhoModel(
            item: item.item.copyWith(
              quantidade: quantity,
              tamanho: selectedSize,
              valorPorTamanho: selectedPrice,
            ),
          );
        },
        ifAbsent: () {
          return CarrinhoModel(
            item: ItemCarrinhoModel(
              quantidade: quantity,
              alimento: selected,
              tamanho: selectedSize,
              valorPorTamanho: selectedPrice,
            ),
          );
        },
      );
    }
  }

  void clear() => carrinho.clear();
}
