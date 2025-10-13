import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
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
    await getDay();
  }

  Future<void> getMenu() async {
    _loading.toggle();
    final menuData = await _lunchboxesServices.getMenu();
    menu.assignAll(menuData);
    log('MENU CONTROLER: $menu');
  }

  Future<void> getAlimentos() async {
    _loading.toggle();
    final alimentoData = await _lunchboxesServices.getFood();
    alimentos.assignAll(alimentoData);
    _loading.toggle();
  }

  Future<void> getDay() async {
    _loading.toggle();
    final dayData = await _lunchboxesServices.getData();
    days.assignAll(dayData);
    _loading.toggle();
  }
}
