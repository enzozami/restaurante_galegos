import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';

class RegisterController extends GetxController {
  final isChecked = false.obs;

  void isToggleCheckBox(bool? value) {
    if (value != null) {
      isChecked.value = value;
    }
  }

  FormFieldValidator<String?> isValidCNPJOrCPF() {
    if (isChecked.value) {
      return Validatorless.multiple([
        Validatorless.required('CNPJ obrigatório'),
        Validatorless.cnpj('CNPJ inválido'),
      ]);
    } else {
      return Validatorless.multiple([
        Validatorless.required('CPF obrigatório'),
        Validatorless.cpf('CPF inválido'),
      ]);
    }
  }
}
