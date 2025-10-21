import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/models/item_carrinho.dart';
import 'package:restaurante_galegos/app/models/shopping_card_model.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/shopping/shopping_card_services.dart';

class ShoppingCardController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderServices _orderServices;
  final AuthService _authService;

  final ShoppingCardServices _cardServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final quantityRx = Rxn<int>();
  int get quantity => quantityRx.value!.toInt();

  void clear() => _cardServices.clear();

  ShoppingCardController({
    required OrderServices orderServices,
    required AuthService authService,
    required ShoppingCardServices cardServices,
  })  : _orderServices = orderServices,
        _authService = authService,
        _cardServices = cardServices;

  List<ShoppingCardModel> get products => _cardServices.productsSelected;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    // ever(quantityRx, (quantity) {
    //   _totalPrice(quantity?.toDouble());
    // });
  }

  void addQuantityProduct(ShoppingCardModel shoppingCardModel) {
    _cardServices.addOrUpdateProduct(shoppingCardModel.product,
        quantity: shoppingCardModel.quantity + 1);
  }

  void removeQuantityProduct(ShoppingCardModel shoppingCardModel) {
    _cardServices.addOrUpdateProduct(shoppingCardModel.product,
        quantity: shoppingCardModel.quantity - 1);
  }

  void addQuantityFood(ShoppingCardModel shoppingCardModel) {
    _cardServices.addOrUpdateFood(
      shoppingCardModel.food,
      quantity: shoppingCardModel.quantity + 1,
      selectedSize: shoppingCardModel.selectSize ?? '',
    );
  }

  void removeQuantityFood(ShoppingCardModel shoppingCardModel) {
    _cardServices.addOrUpdateFood(
      shoppingCardModel.food,
      quantity: shoppingCardModel.quantity - 1,
      selectedSize: shoppingCardModel.selectSize ?? '',
    );
  }

  Future<void> createOrder({required String address}) async {
    try {
      _loading.toggle();
      final user = _authService.getUserId();
      log('USUÁRIO: $user');
      final order = ItemCarrinho(
        userId: user!,
        address: address,
        items: _cardServices.productsSelected,
        quantity: quantity,
      );

      log('ORDER-json: ${order.items.map((e) => e.toJson())}');

      var finished = await _orderServices.createOrder(order);
      finished = finished.copyWith(amountToPay: totalPay());
      log('ORDER-FINALIZADO: ${finished.toJson()}');

      createOrder = createOrder.copyWith(amountToPay: totalValue);
      _loading.toggle();
      clear();
      await Get.offNamed('/order/finished', arguments: finished);
    } catch (e, s) {
      _loading.toggle();
      log('Erro ao carregar produtos no carrinho', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao carregar produtos no carrinho',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading(false);
    }
  }

  double? totalPay() {
    return _cardServices.amountToPay;
  }
}
