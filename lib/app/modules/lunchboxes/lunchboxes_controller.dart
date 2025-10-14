import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final menu = <MenuModel>[].obs;
  final alimentos = <AlimentoModel>[].obs;

  final days = <MenuModel>[].obs;

  final dayNow = FormatterHelper.formatDate();

  LunchboxesController({required LunchboxesServices lunchboxesServices})
      : _lunchboxesServices = lunchboxesServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() async {
    super.onReady();
    await getLunchboxes();
  }

  Future<void> getLunchboxes() async {
    _loading.toggle();
    final menuData = await _lunchboxesServices.getMenu();
    menu.assignAll(menuData);
    final dayData = await _lunchboxesServices.getData();
    days.assignAll(dayData);

    final getAlimentos = await _lunchboxesServices.getFood();
    final filtered = getAlimentos.where((e) => e.dayName == dayNow).toList();
    alimentos.assignAll(filtered);

    _loading.toggle();
  }
}
