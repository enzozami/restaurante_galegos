import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:restaurante_galegos/app/modules/history/history_bindings.dart';
import 'package:restaurante_galegos/app/modules/history/history_page.dart';

class HistoryRouters {
  HistoryRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/history',
      binding: HistoryBindings(),
      page: () => HistoryPage(),
    ),
  ];
}
