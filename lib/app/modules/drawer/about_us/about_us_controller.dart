import 'dart:developer';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class AboutUsController extends GetxController with LoaderMixin, MessagesMixin {
  final ScrollController scrollController = ScrollController();
  final AboutUsServices _aboutUsServices;
  final AuthServices _authServices = Get.find<AuthServices>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newQuemSomosEC = TextEditingController();
  final TextEditingController newFilosofia = TextEditingController();
  final TextEditingController newPorqueNos = TextEditingController();
  final TextEditingController newBuffet = TextEditingController();
  final TextEditingController newServicos = TextEditingController();
  final TextEditingController newMarmitas = TextEditingController();

  final RxString quemSomos = ''.obs;
  final RxString filosofia = ''.obs;
  final RxString porqueNos = ''.obs;
  final RxString buffet = ''.obs;
  final RxString servicos = ''.obs;
  final RxString marmitas = ''.obs;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  RxBool get loading => _loading;
  bool get admin => _authServices.isAdmin();

  AboutUsController({required AboutUsServices aboutUsServices})
    : _aboutUsServices = aboutUsServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
    _fetchAboutUs();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    newQuemSomosEC.dispose();
    newFilosofia.dispose();
    newPorqueNos.dispose();
    newBuffet.dispose();
    newServicos.dispose();
    newMarmitas.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _fetchAboutUs() async {
    try {
      _loading.value = true;

      final data = await _aboutUsServices.getAboutUs();

      quemSomos.value = data.we;
      filosofia.value = data.philosophy;
      porqueNos.value = data.whyChooseUs;
      buffet.value = data.buffet;
      servicos.value = data.service;
      marmitas.value = data.lunchboxes;

      _fillControllers();
    } catch (e) {
      log('$e');
      _loading.value = false;
    } finally {
      _loading.value = false;
    }
  }

  void _fillControllers() {
    newQuemSomosEC.text = quemSomos.value;
    newFilosofia.text = filosofia.value;
    newPorqueNos.text = porqueNos.value;
    newBuffet.text = buffet.value;
    newServicos.text = servicos.value;
    newMarmitas.text = marmitas.value;
  }

  bool validatedForm() => formKey.currentState?.validate() ?? false;

  void desfazerAlteracoes() {
    try {
      _loading.value = true;
      newQuemSomosEC.text = quemSomos.value;
      newFilosofia.text = filosofia.value;
      newPorqueNos.text = porqueNos.value;
      newBuffet.text = buffet.value;
      newServicos.text = servicos.value;
      newMarmitas.text = marmitas.value;
    } finally {
      _loading.value = false;
    }
  }

  Future<void> atualizarDados() async {
    try {
      _loading.value = true;
      if (!validatedForm()) {
        _message.value = MessageModel(
          title: 'Erro',
          message: 'Erro ao validar formulário',
          type: MessageType.error,
        );
        return;
      }

      await _aboutUsServices.updateData(
        newQuemSomosEC.text,
        newFilosofia.text,
        newPorqueNos.text,
        newBuffet.text,
        newServicos.text,
        newMarmitas.text,
      );

      if (newQuemSomosEC.text.isNotEmpty) quemSomos.value = newQuemSomosEC.text;
      if (newFilosofia.text.isNotEmpty) filosofia.value = newFilosofia.text;
      if (newPorqueNos.text.isNotEmpty) porqueNos.value = newPorqueNos.text;
      if (newBuffet.text.isNotEmpty) buffet.value = newBuffet.text;
      if (newServicos.text.isNotEmpty) servicos.value = newServicos.text;
      if (newMarmitas.text.isNotEmpty) marmitas.value = newMarmitas.text;
    } catch (e) {
      log(e.toString());
    } finally {
      _loading.value = false;
    }
  }
}
