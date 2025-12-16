import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/enum/payment_type.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/icons.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/endereco_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/modules/home/home_controller.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class FinishOrderController extends GetxController with LoaderMixin, MessagesMixin {
  final homeController = Get.find<HomeController>();
  final args = Get.arguments;

  final AuthServices _authServices;
  final OrderServices _orderServices;
  final CarrinhoServices _carrinhoServices;

  final date = FormatterHelper.formatDateNumber();
  final time = FormatterHelper.formatDateAndTime();
  var id = 0;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final isProcessing = false.obs;
  final formKey = GlobalKey<FormState>();
  final quantityRx = Rxn<int>();

  RxBool get loading => _loading;
  int get quantity => quantityRx.value ?? 0;
  // List<CarrinhoModel> get products => _carrinhoServices.itensCarrinho;

  FinishOrderController({
    required AuthServices authServices,
    required OrderServices orderServices,
    required CarrinhoServices carrinhoServices,
  }) : _authServices = authServices,
       _orderServices = orderServices,
       _carrinhoServices = carrinhoServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  Future<bool> createOrder() async {
    final List<CarrinhoModel> products = args['itens'];
    final numero = args['numero'];
    if (isProcessing.value) return false;
    _loading.value = true;
    log('Status do loading INICIAL: ${loading.value}');
    isProcessing.value = true;
    bool sucesso = false;
    try {
      final user = _authServices.getUserId();
      final name = _authServices.getUserName();
      final id = await _orderServices.generateSequentialOrderId();
      quantityRx.value = products.fold<int>(0, (sum, e) => sum + e.item.quantidade);

      if (numero == null) {
        _loading.value = false;
        await 50.milliseconds.delay();
        _message(
          MessageModel(
            title: 'Erro',
            message: 'Número da residência inválido',
            type: MessageType.error,
          ),
        );
        return false;
      }

      final total = args['preco'] + args['taxa'];
      log('LOG - PRECO - PEDIDOMODEL - $total');

      log('FORMULÁRIO VALIDADO');
      final order = PedidoModel(
        id: id,
        userId: user!,
        endereco: EnderecoModel(
          cep: args['cep'],
          rua: args['rua'],
          bairro: args['bairro'],
          cidade: args['cidade'],
          estado: args['estado'],
          numeroResidencia: numero,
        ),
        cart: _carrinhoServices.itensCarrinho,
        amountToPay: total,
        taxa: args['taxa'],
        status: 'preparando',
        userName: name ?? '',
        date: date,
        time: time,
        timeFinished: '',
      );

      log('PEDIDO - ${order.toString()}');
      await _orderServices.createOrder(order);

      Get.close(4);
      homeController.selectedIndex = 3;

      _carrinhoServices.clear();

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
      log('PRIMEIRO SEGUNDO');
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
  }

  IconData getIconData() {
    if (args['payment'] == PaymentType.cartao) {
      return Restaurante.credit_card;
    } else if (args['payment'] == PaymentType.vale) {
      return Restaurante.ticket_alt;
    } else if (args['payment'] == PaymentType.dinheiro) {
      return Restaurante.money_bill_wave;
    }
    return Icons.abc;
  }

  String getNamePaymentType() {
    if (args['payment'] == PaymentType.cartao) {
      return 'Cartão';
    } else if (args['payment'] == PaymentType.vale) {
      return 'Vale';
    } else if (args['payment'] == PaymentType.dinheiro) {
      return 'Dinheiro';
    } else if (args['payment'] == PaymentType.pix) {
      return 'PIX';
    }
    return 'NENHUM';
  }

  String? getType() {
    if (args['payment'] == PaymentType.cartao) {
      if (args['type'] == CardType.credito) {
        return 'Crédito';
      } else {
        return 'Débito';
      }
    } else if (args['payment'] == PaymentType.vale) {
      if (args['type'] == ValeType.alimentacao) {
        return 'Alimentação';
      } else {
        return 'Refeição';
      }
    } else if (args['payment'] == PaymentType.dinheiro) {
      return FormatterHelper.formatCurrency(args['type']);
    }
    return null;
  }
}
