import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/models/order_model.dart';
import 'package:restaurante_galegos/app/models/shopping_card_model.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/shopping/shopping_card_services.dart';

class ShoppingCardController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderServices _orderServices;
  final AuthService _authService;
  final ShoppingCardServices _cardServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final _address = ''.obs;

  ShoppingCardController({
    required OrderServices orderServices,
    required AuthService authService,
    required ShoppingCardServices cardServices,
  })  : _orderServices = orderServices,
        _authService = authService,
        _cardServices = cardServices;

  List<ShoppingCardModel> get products => _cardServices.products;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void createOrder() {
    _loading.toggle();
    final user = _authService.getUserId();
    log('USUÁRIO: $user');
    final order = OrderModel(
      userId: user!,
      address: _address.value,
      items: _cardServices.products,
    );

    _orderServices.createOrder(order);
  }
}
