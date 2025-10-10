import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';

class LunchboxesController extends GetxController with LoaderMixin {
  final _loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
  }

  void aparecerLoading() async {
    _loading(true);
    await 5.seconds.delay();
    _loading(false);
  }
}
