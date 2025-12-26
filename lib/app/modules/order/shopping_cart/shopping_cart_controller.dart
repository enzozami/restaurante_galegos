import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class ShoppingCartController extends GetxController with LoaderMixin, MessagesMixin {
  final CarrinhoServices _carrinhoServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  RxBool get loading => _loading;
  List<CarrinhoModel> get products => _carrinhoServices.itensCarrinho;

  ShoppingCartController({
    required CarrinhoServices carrinhoServices,
  }) : _carrinhoServices = carrinhoServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void addQuantityProduct(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateProduct(
      shoppingCardModel.item.produto!,
      quantity: shoppingCardModel.item.quantidade + 1,
    );
  }

  void removeQuantityProduct(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateProduct(
      shoppingCardModel.item.produto!,
      quantity: shoppingCardModel.item.quantidade - 1,
    );
  }

  void addQuantityFood(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateFood(
      shoppingCardModel.item.alimento!,
      quantity: shoppingCardModel.item.quantidade + 1,
      selectedSize: shoppingCardModel.item.tamanho ?? '',
    );
  }

  void removeQuantityFood(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateFood(
      shoppingCardModel.item.alimento!,
      quantity: shoppingCardModel.item.quantidade - 1,
      selectedSize: shoppingCardModel.item.tamanho ?? '',
    );
  }

  double? totalPay() {
    return _carrinhoServices.amountToPay ?? 0;
  }

  void clear() => _carrinhoServices.clear();

  void adicionarQuantidadeCarrinho(CarrinhoModel p) {
    if (p.item.alimento != null) {
      addQuantityFood(p);
    } else if (p.item.produto != null) {
      addQuantityProduct(p);
    }
  }

  void removerQuantidadeCarrinho(CarrinhoModel p) {
    if (p.item.alimento != null) {
      removeQuantityFood(p);
    } else if (p.item.produto != null) {
      removeQuantityProduct(p);
    }
  }

  Map<String, dynamic>? args() {
    return {
      'preco': totalPay(),
      'itens': products,
    };
  }
}
