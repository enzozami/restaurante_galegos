import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class ProfileController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;

  final formKey = GlobalKey<FormState>();
  final TextEditingController newNameEC = TextEditingController();

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final RxString nameClient = ''.obs;
  final RxString phoneClient = ''.obs;
  final RxString emailClient = ''.obs;

  ProfileController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    final user = await _authServices.getUser();
    log('user - $user');
    nameClient.value = user.nome;
    phoneClient.value = user.phone;
    emailClient.value = user.email;
  }

  @override
  void onClose() {
    newNameEC.dispose();
    super.onClose();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> updateName() async {
    try {
      _loading.value = true;
      final user = _authServices.getUserName();
      if (user != null) {
        if (newNameEC.text.length <= 150) {
          await _authServices.updateUserName(newName: newNameEC.text);
        } else {
          _message.value = MessageModel(
            title: 'Erro',
            message: 'Nome muito grande! Não foi possível fazer a atualização',
            type: MessageType.error,
          );
          Get.back();
        }
      }
    } catch (e) {
      _loading.value = false;
      _message.value = MessageModel(
        title: 'Erro',
        message: 'Erro ao atualizar nome',
        type: MessageType.error,
      );
    } finally {
      _loading.value = false;
    }
  }
}
