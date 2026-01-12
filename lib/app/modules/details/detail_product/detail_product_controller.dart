import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';

class DetailProductController extends GetxController with LoaderMixin, MessagesMixin {
  final ProductsServices _productsServices;

  final Rx<ProductModel> productSelected = Rx<ProductModel>(Get.arguments);

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _editing = false.obs;
  final RxBool _valueTemHoje = false.obs;

  RxBool get loading => _loading;
  RxBool get editing => _editing;
  RxBool get valueTemHoje => _valueTemHoje;
  // RxBool get valueTemHoje => productSelected!.temHoje.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newName = TextEditingController();
  final TextEditingController newDescription = TextEditingController();
  final TextEditingController newPrice = TextEditingController();

  DetailProductController({required ProductsServices productsServices})
    : _productsServices = productsServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    newName.text = productSelected.value.name;
    newDescription.text = productSelected.value.description ?? '';
    newPrice.text = FormatterHelper.formatCurrency(productSelected.value.price);
  }

  @override
  void onReady() {
    super.onReady();
    valueTemHoje.value = productSelected.value.temHoje;
  }

  void pressForEditOrCancel() {
    if (_editing.value) {
      _editing.value = false;
      _clear();
    } else {
      _editing.value = true;
    }
  }

  void _clear() {
    newName.text = productSelected.value.name;
    newDescription.text = productSelected.value.description ?? '';
    newPrice.text = FormatterHelper.formatCurrency(productSelected.value.price);
    valueTemHoje.value = productSelected.value.temHoje;
  }

  void changeValueTemHoje(bool value) {
    valueTemHoje.value = value;
  }

  Future<void> atualizarDados() async {
    try {
      _loading.value = true;
      if (!validateForm()) {
        _message.value = MessageModel(
          title: 'Erro',
          message: 'Erro ao validar formulário',
          type: MessageType.error,
        );
      }

      await _productsServices.atualizarDados(
        product: productSelected.value,
        newName: newName.text.isNotEmpty ? newName.text : null,
        newDescription: newDescription.text.isNotEmpty ? newDescription.text : null,
        newPrice: newPrice.text.isNotEmpty ? _undoCurrentFormatPrice() : null,
        newTemHoje: valueTemHoje.value,
      );

      productSelected.update((val) {
        if (newName.text.isNotEmpty) val?.name = newName.text;
        if (newDescription.text.isNotEmpty) val?.description = newDescription.text;
        if (newPrice.text.isNotEmpty) {
          val?.price = _undoCurrentFormatPrice();
        }
      });
      pressForEditOrCancel();
    } catch (e) {
      log(e.toString());
      _loading.value = false;
    } finally {
      _loading.value = false;
    }
  }

  double _undoCurrentFormatPrice() {
    return double.parse(newPrice.text.replaceAll(r'R$', '').replaceAll(',', '.'));
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
