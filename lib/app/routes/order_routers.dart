import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/order/checkout/checkout_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/checkout/checkout_page.dart';
import 'package:restaurante_galegos/app/modules/order/delivery_address/delivery_address_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/delivery_address/delivery_address_page.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_page.dart';
import 'package:restaurante_galegos/app/modules/order/order_management/order_management_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/order_management/order_management_page.dart';
import 'package:restaurante_galegos/app/modules/order/order_tracking/order_tracking_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/order_tracking/order_tracking_page.dart';
import 'package:restaurante_galegos/app/modules/order/payment/payment_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/payment/payment_page.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_cart/shopping_cart_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_cart/shopping_cart_page.dart';

class OrderRouters {
  OrderRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/order/shopping',
      binding: ShoppingCartBindings(),
      page: () => ShoppingCartPage(),
    ),
    GetPage(
      name: '/allOrders',
      binding: OrderManagementBindings(),
      page: () => OrderManagementPage(),
    ),
    GetPage(
      name: '/forDelivery',
      binding: OrderTrackingBindings(),
      page: () => OrderTrackingPage(),
    ),
    GetPage(
      name: '/order/finished',
      binding: OrderFinishedBindings(),
      page: () => OrderFinishedPage(),
    ),
    GetPage(
      name: '/address',
      binding: DeliveryAddressBindings(),
      page: () => DeliveryAddressPage(),
    ),
    GetPage(
      name: '/payment',
      binding: PaymentBindings(),
      page: () => PaymentPage(),
    ),
    GetPage(
      name: '/order/finish',
      binding: CheckoutBindings(),
      page: () => CheckoutPage(),
    ),
  ];
}
