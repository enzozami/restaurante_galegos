import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/cep_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/modules/home/home_controller.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class ShoppingCardController extends GetxController with LoaderMixin, MessagesMixin {
  final homeController = Get.find<HomeController>();

  final OrderServices _orderServices;
  final AuthServices _authServices;
  final CepServices _cepServices;
  final CarrinhoServices _carrinhoServices;

  final cepEC = TextEditingController();
  final numeroEC = TextEditingController();

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final cepInput = ''.obs;
  final isProcessing = false.obs;
  final isOpen = true.obs;
  final quantityRx = Rxn<int>();
  final taxa = 0.0.obs;
  final cep = ''.obs;
  final rua = ''.obs;
  final bairro = ''.obs;
  final cidade = ''.obs;
  final estado = ''.obs;
  final numero = ''.obs;
  final cepMok = <CepModel>[].obs;

  final date = FormatterHelper.formatDateNumber();
  final time = FormatterHelper.formatDateAndTime();
  var id = 0;

  RxBool get loading => _loading;
  int get quantity => quantityRx.value ?? 0;
  List<CarrinhoModel> get products => _carrinhoServices.itensCarrinho;

  ShoppingCardController({
    required OrderServices orderServices,
    required OrderServices ordersState,
    required AuthServices authServices,
    required CarrinhoServices carrinhoServices,
    required CepServices cepServices,
  }) : _orderServices = orderServices,
       _authServices = authServices,
       _carrinhoServices = carrinhoServices,
       _cepServices = cepServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    resetCepTaxa();
  }

  @override
  void onClose() {
    super.onClose();
    cepEC.dispose();
    numeroEC.dispose();
  }

  void addQuantityProduct(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateProduct(
      shoppingCardModel.item.produto!,
      quantity: shoppingCardModel.item.quantidade + 1,
    );
  }

  void removeQuantityProduct(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateProduct(
      shoppingCardModel.item.produto!,
      quantity: shoppingCardModel.item.quantidade - 1,
    );
  }

  void addQuantityFood(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateFood(
      shoppingCardModel.item.alimento!,
      quantity: shoppingCardModel.item.quantidade + 1,
      selectedSize: shoppingCardModel.item.tamanho ?? '',
    );
  }

  void removeQuantityFood(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateFood(
      shoppingCardModel.item.alimento!,
      quantity: shoppingCardModel.item.quantidade - 1,
      selectedSize: shoppingCardModel.item.tamanho ?? '',
    );
  }

  Future<bool> createOrder({required String address, required String numero}) async {
    if (isProcessing.value) return false;
    try {
      _loading.value = true;
      isProcessing.value = true;
      final user = _authServices.getUserId();
      final name = _authServices.getUserName();

      final id = await _orderServices.generateSequentialOrderId();

      final order = PedidoModel(
        id: id,
        userId: user!,
        cep: (address),
        rua: rua.value,
        bairro: bairro.value,
        cidade: cidade.value,
        estado: estado.value,
        numeroResidencia: int.parse(numero),
        cart: _carrinhoServices.itensCarrinho,
        amountToPay: totalPay(taxa.value)!,
        taxa: taxa.value,
        status: 'preparando',
        userName: name ?? '',
        date: date,
        time: time,
        timeFinished: '',
      );
      await _orderServices.createOrder(order);
      reset();
      homeController.selectedIndex = 0;

      return true;
    } catch (e, s) {
      log('Erro ao carregar produtos no carrinho', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao carregar produtos no carrinho',
          type: MessageType.error,
        ),
      );
      return false;
    } finally {
      _loading.value = false;
      isProcessing.value = false;
    }
  }

  Future<void> getCep({required String address, required FocusNode numeroFocus}) async {
    try {
      _loading.value = true;
      final cepData = await _cepServices.getCep(address);
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
    } catch (e, s) {
      log('Erro ao buscar CEP: $e');
      log('StackTrace: $s');
      Get.snackbar(
        'Erro',
        'Digite algum CEP válido para finalizar compra!',
        duration: 3.seconds,
        backgroundColor: GalegosUiDefaut.colorScheme.primary,
      );
      rethrow;
    } finally {
      _loading.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(numeroFocus);
      });
    }
  }

  void closeCard() {
    isOpen.value = !isOpen.value;
  }

  double? totalPay(double? taxa) {
    return (_carrinhoServices.amountToPay ?? 0) + (taxa ?? 0);
  }

  void reset() {
    clear(); // limpa os itens do carrinho
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

  void clear() => _carrinhoServices.clear();
}
