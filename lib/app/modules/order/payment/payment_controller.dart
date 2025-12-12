import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/enum/payment_type.dart';

class PaymentController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController trocoEC = TextEditingController();

  final args = Get.arguments;

  final paymentType = PaymentType.nulo.obs;
  final cardType = CardType.credito.obs;
  final valeType = ValeType.alimentacao.obs;

  void changePaymentType(PaymentType value) {
    paymentType.value = value;
  }

  void changeCardType(CardType card) {
    cardType.value = card;
  }

  void changeValeType(ValeType vale) {
    valeType.value = vale;
  }

  Map<String, dynamic>? arguments() {
    var troco = double.tryParse(trocoEC.text);
    troco ??= 0.0;
    return {
      'preco': args['preco'],
      'itens': args['itens'],
      'cep': args['cep'],
      'rua': args['rua'],
      'bairro': args['bairro'],
      'cidade': args['cidade'],
      'estado': args['estado'],
      'numero': args['numero'],
      'taxa': args['taxa'],
      'payment': paymentType.value,
      'type': (paymentType.value == PaymentType.cartao)
          ? cardType
          : (paymentType.value == PaymentType.vale)
          ? valeType
          : (_validateForm())
          ? troco
          : null,
    };
  }

  bool _validateForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
