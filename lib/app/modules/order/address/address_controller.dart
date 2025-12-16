import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/cep_model.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';

class AddressController extends GetxController with LoaderMixin, MessagesMixin {
  final CepServices _cepServices;

  AddressController({required CepServices cepServices}) : _cepServices = cepServices;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController cepEC = TextEditingController();
  final TextEditingController numeroEC = TextEditingController();
  late final FocusNode numeroFocus;
  final MaskCep cepFormatter = MaskCep();

  final args = Get.arguments;

  final cepInput = ''.obs;
  final cep = ''.obs;
  final isProcessing = false.obs;
  final isOpen = false.obs;
  final quantityRx = Rxn<int>();
  final taxa = 0.0.obs;
  final rua = ''.obs;
  final bairro = ''.obs;
  final cidade = ''.obs;
  final estado = ''.obs;
  final numero = ''.obs;
  final cepMok = <CepModel>[].obs;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  RxBool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
    numeroFocus = FocusNode();
  }

  @override
  void onClose() {
    super.onClose();
    cepEC.dispose();
    numeroEC.dispose();
  }

  bool _validateForm() => formKey.currentState?.validate() ?? false;

  Future<void> getCep() async {
    try {
      if (!_validateForm()) return;
      _loading.value = true;

      final unmaskedCep = cepFormatter.getUnmaskedText();

      final cepData = await _cepServices.getCep(unmaskedCep);

      cep.value = cepData['cep'] ?? '';
      rua.value = cepData['logradouro'];
      bairro.value = cepData['bairro'];
      cidade.value = cepData['localidade'];
      estado.value = cepData['uf'];

      final cepMokData = await _cepServices.getCepModel();
      cepMok.value = cepMokData;

      final cepLimpo = cep.value.replaceAll('-', '').trim();

      for (final cepModel in cepMok) {
        log('message: $cepModel');
        if (cepModel.ceps.contains(cepLimpo)) {
          taxa.value = cepModel.taxa;
          break;
        }
      }
      isOpen.value = true;
    } catch (e, s) {
      _loading.value = false;
      log('Erro ao buscar CEP: $e');
      log('StackTrace: $s');
      await 500.milliseconds.delay();
      _message.value = MessageModel(
        title: 'Erro',
        message: 'Digite um CEP válido para finalizar compra!',
        type: MessageType.error,
      );
      rethrow;
    } finally {
      _loading.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(numeroFocus);
      });
    }
  }

  void resetCepTaxa() {
    taxa.value = 0.0;
    cep.value = '';
    rua.value = '';
    bairro.value = '';
    cidade.value = '';
    estado.value = '';
    numero.value = '';
    numeroEC.text = '';
    cepEC.text = '';
  }

  bool addressValidation() {
    return cepEC.text.isNotEmpty &&
        cepEC.text != '' &&
        cep.value != '' &&
        cepInput.value.length == 9 &&
        cepInput.value == cep.value;
  }


  Future<void> enviarDadosParaPagamento()  async {
    final numero = int.tryParse(numeroEC.text);
    try {
      _loading.value = true;
      if (numero != null) {
        if (_validateForm()) {
          _loading.value = false;
          Get.toNamed('/payment', arguments: {
            'preco': args['preco'],
            'itens': args['itens'],
            'cep': cepFormatter.getUnmaskedText(),
            'rua': rua.value,
            'bairro': bairro.value,
            'cidade': cidade.value,
            'estado': estado.value,
            'numero': numero,
            'taxa': taxa.value,
          });
        }
      } else {
        _loading.value = false;
        await 50.milliseconds.delay();
        _message(
          MessageModel(title: 'Erro', message: 'Número inválido', type: MessageType.error,),
        );
      }
    } catch (e) {
      _loading.value = false;
      await 50.milliseconds.delay();
      log('Erro ao obter argumentos: $e');
      _message(
        MessageModel(title: 'Erro', message: 'Número não informado', type: MessageType.error,),
      );
    }
  }

  bool validationOnReplacement() {
    return cepEC.text.isNotEmpty && cepInput.value.length == 9;
  }

  bool validationIsOpen() {
    return isOpen.value == true;
  }

  void closeCard() {
    isOpen.value = !isOpen.value;
  }
}
