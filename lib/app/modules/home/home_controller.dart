import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/modules/history/history_page.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_page.dart';
import 'package:restaurante_galegos/app/modules/order/all_orders/all_orders_page.dart';
import 'package:restaurante_galegos/app/modules/order/for_delivery/for_delivery_page.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_page.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_page.dart';
import 'package:restaurante_galegos/app/modules/products/products_page.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class HomeController extends GetxController {
  // ignore: non_constant_identifier_names
  static const NAVIGATOR_KEY = 1;

  final CarrinhoServices _carrinhoServices;
  final AuthService _authService;

  List<Widget> _pages = [];

  List<Widget> get pages => _pages;

  final _selectedIndex = 0.obs;
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
    if (isAdmin) {
      _pages = [
        AllOrdersPage(),
        ForDeliveryPage(),
        OrderFinishedPage(),
        ProductsPage(),
        LunchboxesPage(),
        ShoppingCardPage(),
      ];
    } else {
      _pages = [
        ProductsPage(),
        LunchboxesPage(),
        ShoppingCardPage(),
        HistoryPage(),
      ];
    }
  }

  set selectedIndex(int index) {
    _selectedIndex.value = index;
  }

  int get selectedIndex => _selectedIndex.value;
  int get totalProducts => _carrinhoServices.totalProducts;
}
