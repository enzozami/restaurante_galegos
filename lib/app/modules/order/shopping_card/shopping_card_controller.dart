import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cep.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController cepEC = TextEditingController();
  final TextEditingController numeroEC = TextEditingController();
  late final FocusNode numeroFocus;
  final MaskCep cepFormatter = MaskCep();
  final date = FormatterHelper.formatDateNumber();
  final time = FormatterHelper.formatDateAndTime();
  var id = 0;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final cepInput = ''.obs;
  final cep = ''.obs;
  final isProcessing = false.obs;
  final isOpen = true.obs;
  final quantityRx = Rxn<int>();
  final taxa = 0.0.obs;
  final rua = ''.obs;
  final bairro = ''.obs;
  final cidade = ''.obs;
  final estado = ''.obs;
  final numero = ''.obs;
  final cepMok = <CepModel>[].obs;

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
    numeroFocus = FocusNode();
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

  Future<bool> createOrder() async {
    if (isProcessing.value) return false;
    _loading.value = true;
    log('Status do loading INICIAL: ${loading.value}');
    isProcessing.value = true;
    bool sucesso = false;
    try {
      if (!validateForm()) {
        _message(
          MessageModel(
            title: 'Erro',
            message: 'Preencha todos os campos',
            type: MessageType.error,
          ),
        );
        return false;
      }

      final user = _authServices.getUserId();
      final name = _authServices.getUserName();
      final id = await _orderServices.generateSequentialOrderId();
      quantityRx.value = products.fold<int>(0, (sum, e) => sum + e.item.quantidade);

      final numero = int.tryParse(numeroEC.text);
      if (numero == null) {
        _message(
          MessageModel(
            title: 'Erro',
            message: 'Número da residência inválido',
            type: MessageType.error,
          ),
        );
        return false;
      }

      log('FORMULÁRIO VALIDADO');
      final order = PedidoModel(
        id: id,
        userId: user!,
        cep: cepFormatter.getUnmaskedText(),
        rua: rua.value,
        bairro: bairro.value,
        cidade: cidade.value,
        estado: estado.value,
        numeroResidencia: numero,
        cart: _carrinhoServices.itensCarrinho,
        amountToPay: totalPay(taxa.value)!,
        taxa: taxa.value,
        status: 'preparando',
        userName: name ?? '',
        date: date,
        time: time,
        timeFinished: '',
      );

      log('PEDIDO - ${order.toString()}');
      await _orderServices.createOrder(order);

      reset();
      homeController.selectedIndex = 0;

      log('Depois do reset');

      sucesso = true;
    } on Exception catch (e, s) {
      _loading.value = false;
      log('Número inválido', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Formato de número inválido. Tente novamente!',
          type: MessageType.error,
        ),
      );
      throw Exception('Número inválido');
    } catch (e, s) {
      _loading.value = false;
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
      log('TESTE FINALIZADO');
      _loading.value = false;
      log('Status do loading FINAL: ${loading.value}');
      isProcessing.value = false;
    }

    if (sucesso) {
      await 500.milliseconds.delay();
      _message(
        MessageModel(
          title: 'Pedido feito com sucesso',
          message: 'Seu pedido foi enviado e está sendo preparado!',
          type: MessageType.info,
        ),
      );
      return true;
    }
    // return sucesso;
  }

  Future<void> getCep() async {
    try {
      _loading.value = true;
      final cepData = await _cepServices.getCep(cepFormatter.getUnmaskedText());
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
      500.milliseconds.delay();
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

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  bool addressValidation() {
    return cepEC.text.isNotEmpty &&
        cepEC.text != '' &&
        cep.value != '' &&
        cepInput.value.length == 9 &&
        cepInput.value == cep.value;
  }

  bool validationOnReplacement() {
    return cepEC.text.isNotEmpty && cepInput.value.length == 9;
  }

  bool validationIsOpen() {
    return isOpen.value == true && cepInput.value.length == 9 && cepInput.value == cep.value;
  }

  void adicionarQuantidadeCarrinho(CarrinhoModel p) {
    if (p.item.alimento != null) {
      addQuantityFood(p);
    } else if (p.item.produto != null) {
      addQuantityProduct(p);
    }
  }

  void removerQuantidadeCarrinho(CarrinhoModel p) {
    if (p.item.alimento != null) {
      removeQuantityFood(p);
    } else if (p.item.produto != null) {
      removeQuantityProduct(p);
    }
  }
}
