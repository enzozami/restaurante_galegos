import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/details/details_bindings.dart';
import 'package:restaurante_galegos/app/modules/details/details_page.dart';

class DetailRouters {
  DetailRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/detail',
      binding: DetailsBindings(),
      page: () => DetailsPage(),
    ),
  ];
}
