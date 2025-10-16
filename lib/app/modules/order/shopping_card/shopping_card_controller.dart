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

  final _address = ''.obs;
  final _quantity = 0.obs;

  // final _price = 0.0.obs;

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
  }

  void createOrder() {
    try {
      _loading.toggle();
      final user = _authService.getUserId();
      log('USUÁRIO: $user');
      final order = ItemCarrinho(
        userId: user!,
        address: _address.value,
        items: _cardServices.productsSelected,
        quantity: _quantity.value,
      );

      _orderServices.createOrder(order);

      _loading.toggle();
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
