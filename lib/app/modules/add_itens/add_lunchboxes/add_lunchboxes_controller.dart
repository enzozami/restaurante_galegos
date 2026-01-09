import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';

class AddLunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;

  RxList<TimeModel> get times => _lunchboxesServices.times;
  final RxList<String> days = <String>[].obs;
  final RxBool _loading = false.obs;
  final Rxn<MessageModel> _message = Rxn<MessageModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nomeEC = TextEditingController();
  final TextEditingController descricaoEC = TextEditingController();
  final TextEditingController precoMini = TextEditingController();
  final TextEditingController precoMedia = TextEditingController();

  AddLunchboxesController({required LunchboxesServices lunchboxesServices})
    : _lunchboxesServices = lunchboxesServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  Future<void> cadastrarNovasMarmitas() async {
    if (days.isEmpty) {
      _message.value = MessageModel(
        title: 'Atenção',
        message: 'Selecione ao menos um dia para cadastrar.',
        type: MessageType.error,
      );
      return;
    }
    try {
      _loading.value = true;

      if (!_validateForm()) {
        _loading.value = false;
        return;
      }
      await _lunchboxesServices.cadastrarMarmita(
        name: nomeEC.text,
        days: days,
        description: descricaoEC.text,
        prices: {
          'mini': _undoFormatPrice(precoMini.text),
          'media': _undoFormatPrice(precoMedia.text),
        },
      );

      await _lunchboxesServices.refreshData();
      _clear();

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.back();
    } catch (e) {
      _loading.value = false;
      _message.value = MessageModel(
        title: 'Erro',
        message: 'Erro ao cadastrar marmita',
        type: MessageType.error,
      );
    } finally {
      _loading.value = false;
    }
  }

  void _clear() {
    nomeEC.clear();
    descricaoEC.clear();
    precoMini.clear();
    precoMedia.clear();
    days.clear();
  }

  double _undoFormatPrice(String value) {
    return double.parse(value.replaceAll(r'R$ ', '').replaceAll(',', '.'));
  }

  bool _validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void onChangedSelectionFunctionEditing(
    List<Object?> allSelectedItems,
    Object? selectedItem,
  ) {
    days.value = allSelectedItems.map((e) => e as String).toList();
  }
}
