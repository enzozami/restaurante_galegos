import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';

class DetailLunchboxAdmController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;

  final FoodModel foodSelected = Get.arguments;

  RxList<TimeModel> get times => _lunchboxesServices.times;

  final RxBool _loading = false.obs;
  final Rxn<MessageModel> _message = Rxn<MessageModel>();
  final RxBool _editing = false.obs;
  final RxBool _valueTemHoje = false.obs;

  RxBool get loading => _loading;
  RxBool get editing => _editing;
  RxBool get valueTemHoje => _valueTemHoje;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newName = TextEditingController();
  final TextEditingController newDescription = TextEditingController();
  final TextEditingController newPriceMini = TextEditingController();
  final TextEditingController newPriceMedia = TextEditingController();
  final RxList<String> days = <String>[].obs;

  DetailLunchboxAdmController({required LunchboxesServices lunchboxesServices})
    : _lunchboxesServices = lunchboxesServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    _valueTemHoje.value = foodSelected.temHoje;
    days.value = foodSelected.dayName;
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
    newName.clear();
    newDescription.clear();
    newPriceMini.clear();
    newPriceMedia.clear();
    valueTemHoje.value = foodSelected.temHoje;
    days.value = foodSelected.dayName;
  }

  void changeValueTemHoje(bool value) {
    valueTemHoje.value = value;
  }

  Future<void> atualizarDados() async {
    try {
      _loading.value = true;
      if (days.isEmpty) {}
      if (!validateForm()) {
        _message.value = MessageModel(
          title: 'Erro',
          message: 'Erro ao validar formulário',
          type: MessageType.error,
        );
      }

      await _lunchboxesServices.updateData(
        food: foodSelected,
        newName: newName.text.isNotEmpty ? newName.text : null,
        newDescription: newDescription.text.isNotEmpty ? newDescription.text : null,
        newPrices: newPriceMini.text.isNotEmpty && newPriceMedia.text.isNotEmpty
            ? {
                'mini': double.parse(
                  newPriceMini.text.replaceAll('R\$ ', '').replaceAll(',', '').replaceAll('.', ''),
                ),
                'media': double.parse(
                  newPriceMedia.text.replaceAll('R\$ ', '').replaceAll(',', '').replaceAll('.', ''),
                ),
              }
            : null,
        newTemHoje: valueTemHoje.value,
        newDays: days.value,
      );
      pressForEditOrCancel();
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      _loading.value = false;
    }
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void onChangedSelectionFunctionEditing(
    List<Object?> allSelectedItems,
    Object? selectedItem,
  ) {
    foodSelected.dayName = allSelectedItems.cast<String>();
    days.value = allSelectedItems.map((e) => e as String).toList();
  }

  // TODO - CONTINUAR IMPLEMENTAÇÃO DOS CARDS DE DIAS NA TELA DE DETALHE

  // void onChangedSelectionFunctionDetail(
  //   List<Object?> allSelectedItems,
  //   String selectedItem,
  // ) {
  //   log('allSelectedItems - $allSelectedItems');
  //   log('selectedItem - $selectedItem');
  //   foodSelected.dayName = allSelectedItems.cast<String>();
  //   days.value = allSelectedItems.map((e) => e as String).toList();
  // }
}
