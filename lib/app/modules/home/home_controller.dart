import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_bindings.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_page.dart';
import 'package:restaurante_galegos/app/modules/order/order_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/order_page.dart';
import 'package:restaurante_galegos/app/modules/products/products_bindings.dart';
import 'package:restaurante_galegos/app/modules/products/products_page.dart';

class HomeController extends GetxController {
  // ignore: non_constant_identifier_names
  static const NAVIGATOR_KEY = 1;

  final _selectedIndex = 0.obs;
  final _tabs = [
    '/products',
    '/lunchboxes',
    '/order',
  ];

  set selectedIndex(int index) {
    // _selectedIndex(index);
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
    if (settings.name == '/order') {
      return GetPageRoute(
        settings: settings,
        page: () => OrderPage(),
        binding: OrderBindings(),
        transition: Transition.fadeIn,
      );
    }
    return null;
  }
}
