import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services.dart';

class AboutUsController extends GetxController with LoaderMixin, MessagesMixin {
  final ScrollController scrollController = ScrollController();
  final AboutUsServices _aboutUsServices;

  final RxString quemSomos = ''.obs;
  final RxString filosofia = ''.obs;
  final RxString porqueNos = ''.obs;
  final RxString buffet = ''.obs;
  final RxString servicos = ''.obs;
  final RxString marmitas = ''.obs;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  RxBool get loading => _loading;

  AboutUsController({required AboutUsServices aboutUsServices})
    : _aboutUsServices = aboutUsServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    try {
      _loading.value = true;
      quemSomos.value = await _aboutUsServices.getAboutUs().then(
        (value) => value.we,
      );
      filosofia.value = await _aboutUsServices.getAboutUs().then(
        (value) => value.philosophy,
      );
      porqueNos.value = await _aboutUsServices.getAboutUs().then(
        (value) => value.whyChooseUs,
      );
      buffet.value = await _aboutUsServices.getAboutUs().then(
        (value) => value.buffet,
      );
      servicos.value = await _aboutUsServices.getAboutUs().then(
        (value) => value.service,
      );
      marmitas.value = await _aboutUsServices.getAboutUs().then(
        (value) => value.lunchboxes,
      );
    } catch (e) {
      log(e.toString());
    } finally {
      _loading.value = false;
    }
  }
}
