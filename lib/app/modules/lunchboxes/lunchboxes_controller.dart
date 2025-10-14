import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final sizes = <String>[].obs;

  final alimentos = <AlimentoModel>[].obs;

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
    final alimentosData = await _lunchboxesServices.getFood();

    final List<String> sizesList = List<String>.from(menuData.first.pricePerSize);

    log('TAMANHOS: $sizesList');

    sizes.assignAll(sizesList);

    final filtered = alimentosData.where((e) => e.dayName == dayNow);

    alimentos.assignAll(filtered);
    _loading.toggle();
  }
}
