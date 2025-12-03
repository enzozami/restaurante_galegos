import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services.dart';

class AboutUsController extends GetxController with LoaderMixin, MessagesMixin {
  final ScrollController scrollController = ScrollController();

  final AboutUsServices _aboutUsServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _titleAboutUs = ''.obs;
  final _textAboutUs = ''.obs;

  String get titleAboutUs => _titleAboutUs.value;
  String get textAboutUs => _textAboutUs.value;

  AboutUsController({required AboutUsServices aboutUsServices})
    : _aboutUsServices = aboutUsServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    getAbout();
  }

  Future<void> getAbout() async {
    _loading(true);
    try {
      final aboutUsData = await _aboutUsServices.getAboutUs();
      _titleAboutUs.value = aboutUsData.title;
      _textAboutUs.value = aboutUsData.text;
    } catch (e) {
      _message(
        MessageModel(
          title: 'Erro ao buscar dados',
          message: 'Erro ao buscar o "sobre nós"',
          type: MessageType.error,
        ),
      );
      log(e.toString());
    } finally {
      _loading(false);
    }
  }
}
