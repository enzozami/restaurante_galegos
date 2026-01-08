import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';

class DetailLunchboxAdmController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;

  // final FoodModel foodSelected = Get.arguments;
  final Rx<FoodModel> foodSelected = Rx<FoodModel>(Get.arguments);

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

    newName.text = foodSelected.value.name;
    newDescription.text = foodSelected.value.description;
    newPriceMini.text = FormatterHelper.formatCurrency(
      foodSelected.value.pricePerSize['mini']!,
    );
    newPriceMedia.text = FormatterHelper.formatCurrency(
      foodSelected.value.pricePerSize['media']!,
    );
  }

  @override
  void onReady() {
    super.onReady();
    _valueTemHoje.value = foodSelected.value.temHoje;
    days.value = foodSelected.value.dayName;
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
    newName.text = foodSelected.value.name;
    newDescription.text = foodSelected.value.description;
    newPriceMini.text = FormatterHelper.formatCurrency(
      foodSelected.value.pricePerSize['mini'] ?? 0,
    );
    newPriceMedia.text = FormatterHelper.formatCurrency(
      foodSelected.value.pricePerSize['media'] ?? 0,
    );
    valueTemHoje.value = foodSelected.value.temHoje;
    days.value = foodSelected.value.dayName;
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

      await _lunchboxesServices.updateData(
        food: foodSelected.value,
        newName: newName.text.isNotEmpty ? newName.text : null,
        newDescription: newDescription.text.isNotEmpty ? newDescription.text : null,
        newPrices: {
          'mini': _undoCurrentFormatPriceMini(),
          'media': _undoCurrentFormatPriceMedia(),
        },
        newTemHoje: valueTemHoje.value,
        newDays: days.value.isNotEmpty ? days.value : null,
      );

      foodSelected.update(
        (val) {
          if (newName.text.isNotEmpty) val?.name = newName.text;
          if (newDescription.text.isNotEmpty) val?.description = newDescription.text;
          val?.dayName = List.from(days);
          if (newPriceMini.text.isNotEmpty) {
            val?.pricePerSize['mini'] = _undoCurrentFormatPriceMini();
          }
          if (newPriceMedia.text.isNotEmpty) {
            val?.pricePerSize['media'] = _undoCurrentFormatPriceMedia();
          }
        },
      );
      pressForEditOrCancel();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    } finally {
      _loading.value = false;
    }
  }

  double _undoCurrentFormatPriceMini() {
    return double.parse(
      newPriceMini.text.replaceAll(r'R$', '').replaceAll('.', '').replaceAll(',', '.'),
    );
  }

  double _undoCurrentFormatPriceMedia() {
    return double.parse(
      newPriceMedia.text.replaceAll(r'R$', '').replaceAll('.', '').replaceAll(',', '.'),
    );
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void onChangedSelectionFunctionEditing(
    List<Object?> allSelectedItems,
    Object? selectedItem,
  ) {
    foodSelected.value.dayName = allSelectedItems.cast<String>();
    days.value = allSelectedItems.map((e) => e as String).toList();
  }
}
