import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/products/products_bindings.dart';
import 'package:restaurante_galegos/app/modules/products/products_page.dart';

class ProductsRouters {
  ProductsRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/products',
      binding: ProductsBindings(),
      page: () => ProductsPage(),
    )
  ];
}
