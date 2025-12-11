import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/enum/payment_type.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';

class PaymentController extends GetxController with LoaderMixin, MessagesMixin {
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
}
