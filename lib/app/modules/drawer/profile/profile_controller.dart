import 'dart:developer';

import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class ProfileController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;

  final formKey = GlobalKey<FormState>();
  final TextEditingController newNameEC = TextEditingController();
  final TextEditingController newEmailEC = TextEditingController();
  final TextEditingController newPhoneEC = TextEditingController();

  final RxBool edit = false.obs;

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
    nameClient.value = user.nome;
    phoneClient.value = user.phone;
    emailClient.value = user.email;
  }

  @override
  void onClose() {
    newNameEC.dispose();
    newEmailEC.dispose();
    newPhoneEC.dispose();
    super.onClose();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void pressForEditOrCancel() {
    if (edit.value) {
      // cancelar
      edit.value = false;
      _clear();
      log('CANCELANDO');
    } else {
      edit.value = true;
      log('EDITANDO');
    }
  }

  void _clear() {
    newPhoneEC.clear();
    newNameEC.clear();
    newEmailEC.clear();
  }

  Future<void> updateData() async {
    try {
      _loading.value = true;
      await _sendDataUpdate();
    } catch (e, s) {
      _loading.value = false;
      log(e.toString());
      log(s.toString());
      _message.value = MessageModel(
        title: 'Erro',
        message: 'Erro ao atualizar dados',
        type: MessageType.error,
      );
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _sendDataUpdate() async {
    try {
      await _authServices.updateData(
        newNameEC.text.isNotEmpty ? newNameEC.text : null,
        newEmailEC.text.isNotEmpty ? newEmailEC.text : null,
        newPhoneEC.text.isNotEmpty ? newPhoneEC.text : null,
      );

      if (newNameEC.text.isNotEmpty) nameClient.value = newNameEC.text;
      if (newEmailEC.text.isNotEmpty) emailClient.value = newEmailEC.text;
      if (newPhoneEC.text.isNotEmpty) phoneClient.value = newPhoneEC.text;

      _message.value = MessageModel(
        title: 'Sucesso',
        message: 'Dados atualizados com sucesso!',
        type: MessageType.info,
      );
      edit.value = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showReauthDialog();
      }
    } finally {
      _loading.value = false;
    }
  }

  void _showReauthDialog() {
    final TextEditingController passwordEC = TextEditingController();

    Get.defaultDialog(
      title: 'Confirme sua Senha',
      content: Column(
        children: [
          const Text('Para alterar e-mail ou telefone, confirme sua senha atual:'),
          const SizedBox(
            height: 10,
          ),
          FancyPasswordField(
            controller: passwordEC,
            decoration: InputDecoration(
              label: Text(
                'Senha',
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: AppColors.title,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.title,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.title,
                ),
              ),
              floatingLabelStyle: TextStyle(
                color: AppColors.title,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.title,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
            cursorColor: AppColors.title,
            hasStrengthIndicator: false,
          ),
        ],
      ),
      confirm: GalegosButtonDefault(
        label: 'Confirmar',
        onPressed: () async {
          try {
            Get.back();
            _loading.value = true;

            await _authServices.reauthenticate(passwordEC.text);

            await _sendDataUpdate();
          } catch (e) {
            _loading.value = false;
            _message.value = MessageModel(
              title: 'Erro',
              message: 'Senha incorreta ou erro na reautenticação.',
              type: MessageType.error,
            );
          } finally {
            _loading.value = false;
          }
        },
      ),
    );
  }
}
