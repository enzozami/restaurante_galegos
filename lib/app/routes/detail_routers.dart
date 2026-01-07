import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/details/detail_lunchboxes/detail_lunchboxes_bindings.dart';
import 'package:restaurante_galegos/app/modules/details/detail_lunchboxes/detail_lunchboxes_page.dart';
import 'package:restaurante_galegos/app/modules/details/detail_order/detail_order_bindings.dart';
import 'package:restaurante_galegos/app/modules/details/detail_order/detail_order_page.dart';
import 'package:restaurante_galegos/app/modules/details/detail_product/detail_product_bindings.dart';
import 'package:restaurante_galegos/app/modules/details/detail_product/detail_product_page.dart';

class DetailRouters {
  DetailRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/detail/lunchboxes',
      binding: DetailLunchboxesBindings(),
      page: () => DetailLunchboxesPage(),
    ),
    GetPage(
      name: '/detail/orders',
      binding: DetailOrderBindings(),
      page: () => DetailOrderPage(),
    ),
    GetPage(
      name: '/detail/product',
      binding: DetailProductBindings(),
      page: () => DetailProductPage(),
    ),
  ];
}
