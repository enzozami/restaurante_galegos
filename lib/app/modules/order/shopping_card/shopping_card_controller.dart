import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/cep_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/modules/home/home_controller.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class ShoppingCardController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderServices _orderServices;
  final AuthService _authService;
  final CepServices _cepServices;

  final cepEC = TextEditingController();
  final cepInput = ''.obs;
  final numeroEC = TextEditingController();

  final isOpen = true.obs;

  final date = FormatterHelper.formatDateNumber();
  final time = FormatterHelper.formatDateAndTime();

  @override
  void onClose() {
    super.onClose();
    cepEC.dispose();
    numeroEC.dispose();
  }

  final CarrinhoServices _carrinhoServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  var id = 0;

  final quantityRx = Rxn<int>();
  int get quantity => quantityRx.value ?? 0;

  void clear() => _carrinhoServices.clear();

  // CEP
  final cep = ''.obs;
  final rua = ''.obs;
  final bairro = ''.obs;
  final cidade = ''.obs;
  final estado = ''.obs;
  final numero = ''.obs;

  // CEP mocado
  final cepMok = <CepModel>[].obs;

  final taxa = 0.0.obs;

  ShoppingCardController({
    required OrderServices orderServices,
    required AuthService authService,
    required CarrinhoServices carrinhoServices,
    required CepServices cepServices,
  })  : _orderServices = orderServices,
        _authService = authService,
        _carrinhoServices = carrinhoServices,
        _cepServices = cepServices;

  List<CarrinhoModel> get products => _carrinhoServices.itensCarrinho;

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

// PARTE PARA ADMIN
  // Future<void> createOrder({required String address}) async {
  //   try {
  //     _loading.toggle();
  //     final user = _authService.getUserId();
  //     log('USUÁRIO: $user');
  //     final order = ItemCarrinho(
  //       userId: user!,
  //       address: address,
  //       items: _cardServices.productsSelected,
  //       quantity: quantity,
  //     );
  //     log('ORDER-json: ${order.items.map((e) => e.toJson())}');
  //     var finished = await _orderServices.createOrder(order);
  //     finished = finished.copyWith(amountToPay: totalPay());
  //     log('ORDER-FINALIZADO: ${finished.toJson()}');
  //     _loading.toggle();
  //     clear();
  //     await Get.offNamed('/order/finished', arguments: finished);
  //   } catch (e, s) {
  //     _loading.toggle();
  //     log('Erro ao carregar produtos no carrinho', error: e, stackTrace: s);
  //     _message(
  //       MessageModel(
  //         title: 'Erro',
  //         message: 'Erro ao carregar produtos no carrinho',
  //         type: MessageType.error,
  //       ),
  //     );
  //   } finally {
  //     _loading(false);
  //   }
  // }
  final homeController = Get.find<HomeController>();

  Future<bool> createOrder({required String address, required String numero}) async {
    try {
      _loading(true);
      final user = _authService.getUserId();
      final name = _authService.getUserName();
      final cpfOrCnpj = _authService.getUserCPFORCNPJ();

      final idOrder = await _orderServices.getIdOrder();
      final idSequencial = idOrder.id + 1;

      final order = PedidoModel(
        id: idSequencial,
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
        cpfOrCnpj: cpfOrCnpj ?? '',
        date: date,
        time: time,
      );
      await _orderServices.createOrder(order);
      reset();

      _loading(false);

      homeController.selectedIndex = 0;

      return true;
    } catch (e, s) {
      _loading(false);
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
      _loading(false);
    }
  }

  Future<void> getCep({required String address}) async {
    try {
      _loading(true);
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
      _loading(false);
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
      _loading(false);
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
    cep.value = '';
    rua.value = '';
    bairro.value = '';
    cidade.value = '';
    estado.value = '';
    numero.value = '';
    numeroEC.text = '';
    cepEC.text = '';
    taxa.value = 0.0;
  }
}
