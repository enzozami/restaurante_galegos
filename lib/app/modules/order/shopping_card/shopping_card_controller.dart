import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/models/order_model.dart';
import 'package:restaurante_galegos/app/models/shopping_card_model.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/shopping/shopping_services.dart';

class ShoppingCardController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderServices _orderServices;
  final AuthService _authService;
  final ShoppingServices _shoppingServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final cart = <ShoppingCardModel>[].obs;

  final _address = ''.obs;

  ShoppingCardController({
    required OrderServices orderServices,
    required AuthService authService,
    required ShoppingServices shoppingServices,
  })  : _orderServices = orderServices,
        _authService = authService,
        _shoppingServices = shoppingServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void addQuantityInItem(ShoppingCardModel shoppingCardModel) {
    _shoppingServices.addAndRemoveItemInShoppingCard(
      shoppingCardModel.product,
      quantity: shoppingCardModel.quantity + 1,
    );
  }

  void addQuantityInFood(ShoppingCardModel shoppingCardModel) {
    _shoppingServices.addAndRemoveFoodInShoppingCard(
      shoppingCardModel.food,
      quantity: shoppingCardModel.quantity + 1,
    );
  }

  void subtractQuantityInItem(ShoppingCardModel shoppingCardModel) {
    _shoppingServices.addAndRemoveItemInShoppingCard(
      shoppingCardModel.product,
      quantity: shoppingCardModel.quantity - 1,
    );
  }

  void subtractQuantityInFood(ShoppingCardModel shoppingCardModel) {
    _shoppingServices.addAndRemoveFoodInShoppingCard(
      shoppingCardModel.food,
      quantity: shoppingCardModel.quantity - 1,
    );
  }

  void createOrder() {
    _loading.toggle();
    final user = _authService.getUserId();
    log('USUÁRIO: $user');
    final order = OrderModel(
      userId: user!,
      address: _address.value,
      items: _shoppingServices.items,
    );

    var newOrder = _orderServices.createOrder(order);
  }
}
