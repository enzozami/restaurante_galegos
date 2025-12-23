import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class DetailLunchboxesController extends GetxController {
  final CarrinhoServices _carrinhoServices;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController observacoes = TextEditingController();

  final FoodModel food = Get.arguments;
  final RxString sizeSelected = ''.obs;
  final _quantity = 1.obs;

  int get quantity => _quantity.value;

  double get price => food.pricePerSize[sizeSelected.value] ?? 0.0;
  double get totalPrice => (food.pricePerSize[sizeSelected.value] ?? 0.0) * _quantity.value;

  // final _loading = false.obs;
  // final _message = Rxn<MessageModel>();
  final isProcessing = false.obs;
  final availableSizes = <String>[].obs;
  final _alreadyAdded = false.obs;

  DetailLunchboxesController({required CarrinhoServices carrinhoServices})
    : _carrinhoServices = carrinhoServices;

  @override
  void onInit() {
    super.onInit();
    itemNoCarrinho();

    if (itemNoCarrinho() != null && itemNoCarrinho()?.item.tamanho != null) {
      sizeSelected.value = itemNoCarrinho()!.item.tamanho!;
      _quantity.value = itemNoCarrinho()!.item.quantidade;
      _alreadyAdded.value = true;
    }
  }

  CarrinhoModel? itemNoCarrinho() {
    return _carrinhoServices.itensCarrinho.firstWhereOrNull((p) => p.item.alimento?.id == food.id);
  }

  void changeSizeSelected(String size) {
    if (sizeSelected.value == size) {
      sizeSelected.value = '';
      _quantity.value = 1;
    } else {
      sizeSelected.value = size;
      definirComidaSelecionada(size);
    }
  }

  void _adicionarMarmitaAoCarrinho() {
    _carrinhoServices.addOrUpdateFood(
      food,
      quantity: _quantity.value,
      selectedSize: sizeSelected.value,
    );
    sizeSelected.value = '';
    Get.back();
  }

  void exibirDialogoAdicionarAoCarrinho({
    required BuildContext context,
  }) {
    _adicionarMarmitaAoCarrinho();
    log(
      'Item: ${food.name} - Valor: ${sizeSelected.value}',
    );
    Get.snackbar(
      'Item: ${food.name}',
      'Item adicionado ao carrinho',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 1),
      backgroundColor: Color(0xFFE2933C),
      colorText: Colors.black,
      isDismissible: true,
      overlayBlur: 0,
      overlayColor: Colors.transparent,
      barBlur: 0,
    );
  }

  void adicionarQuantidade() {
    _quantity.value++;
  }

  void removerQuantidade() {
    if (_quantity.value > 1) _quantity.value--;
  }

  void definirComidaSelecionada(String size) {
    sizeSelected.value = size;
    final carrinhoItem = _carrinhoServices.getByIdAndSize(food.id, sizeSelected.value);
    if (carrinhoItem != null) {
      _quantity.value = carrinhoItem.quantidade;
      _alreadyAdded(true);
    } else {
      _quantity.value = 1;
      _alreadyAdded(false);
    }
  }
}
