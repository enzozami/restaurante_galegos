import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_bindings.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_page.dart';
import 'package:restaurante_galegos/app/modules/order/all_orders/all_orders_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/all_orders/all_orders_page.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_page.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_page.dart';
import 'package:restaurante_galegos/app/modules/products/products_bindings.dart';
import 'package:restaurante_galegos/app/modules/products/products_page.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class HomeController extends GetxController {
  // ignore: non_constant_identifier_names
  static const NAVIGATOR_KEY = 1;

  final CarrinhoServices _carrinhoServices;
  final AuthService _authService;

  final _selectedIndex = 0.obs;
  final _tabs = <String>[].obs;

  final _isAdmin = false.obs;

  bool get isAdmin => _isAdmin.value;

  HomeController({
    required AuthService authService,
    required CarrinhoServices carrinhoServices,
  })  : _carrinhoServices = carrinhoServices,
        _authService = authService;

  @override
  void onInit() {
    super.onInit();
    _isAdmin.value = _authService.isAdmin();
    _tabs.clear();
    log('HomeController - isAdmin: ${_isAdmin.value}');
    if (_isAdmin.value) {
      _tabs.addAll(['/allOrders', '/order/finished', '/products', '/lunchboxes']);
    } else {
      _tabs.addAll(['/products', '/lunchboxes', '/order/shopping']);
    }
  }

  set selectedIndex(int index) {
    _selectedIndex.value = index;
    Get.toNamed(_tabs[index], id: NAVIGATOR_KEY);
  }

  int get selectedIndex => _selectedIndex.value;

  GetPageRoute? onGeneratedRoute(RouteSettings settings) {
    // log('onGeneratedRoute chamado com: ${settings.name}');
    if (settings.name == '/products') {
      return GetPageRoute(
        settings: settings,
        page: () => ProductsPage(),
        binding: ProductsBindings(),
        transition: Transition.fadeIn,
      );
    }
    if (settings.name == '/lunchboxes') {
      return GetPageRoute(
        settings: settings,
        page: () => LunchboxesPage(),
        binding: LunchboxesBindings(),
        transition: Transition.fadeIn,
      );
    }
    if (settings.name == '/order/shopping') {
      return GetPageRoute(
        settings: settings,
        page: () => ShoppingCardPage(),
        binding: ShoppingCardBindings(),
        transition: Transition.fadeIn,
      );
    }
    if (settings.name == '/allOrders') {
      return GetPageRoute(
        settings: settings,
        page: () => AllOrdersPage(),
        binding: AllOrdersBindings(),
        transition: Transition.fadeIn,
      );
    }
    if (settings.name == '/order/finished') {
      return GetPageRoute(
        settings: settings,
        page: () => OrderFinishedPage(),
        binding: OrderFinishedBindings(),
        transition: Transition.fadeIn,
      );
    }
    return null;
  }

  int get totalProducts => _carrinhoServices.totalProducts;
}
