import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/order/address/address_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/address/address_page.dart';
import 'package:restaurante_galegos/app/modules/order/all_orders/all_orders_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/all_orders/all_orders_page.dart';
import 'package:restaurante_galegos/app/modules/order/for_delivery/for_delivery_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/for_delivery/for_delivery_page.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_page.dart';
import 'package:restaurante_galegos/app/modules/order/payment/payment_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/payment/payment_page.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_page.dart';

class OrderRouters {
  OrderRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/order/shopping',
      binding: ShoppingCardBindings(),
      page: () => ShoppingCardPage(),
    ),
    GetPage(
      name: '/allOrders',
      binding: AllOrdersBindings(),
      page: () => AllOrdersPage(),
    ),
    GetPage(
      name: '/forDelivery',
      binding: ForDeliveryBindings(),
      page: () => ForDeliveryPage(),
    ),
    GetPage(
      name: '/order/finished',
      binding: OrderFinishedBindings(),
      page: () => OrderFinishedPage(),
    ),
    GetPage(
      name: '/address',
      binding: AddressBindings(),
      page: () => AddressPage(),
    ),
    GetPage(
      name: '/payment',
      binding: PaymentBindings(),
      page: () => PaymentPage(),
    ),
  ];
}
