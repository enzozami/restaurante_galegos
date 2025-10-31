import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;
  final CarrinhoServices _carrinhoServices;

  // --- ESTADO REATIVO CENTRALIZADO ---
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  // --- DADOS PRINCIPAIS E BACKUPS ---
  // Renomear para 'availableSizes' para clareza
  final availableSizes = <String>[].obs;
  final _availableSizesOriginal = <String>[];

  final alimentos = <FoodModel>[].obs;
  final _alimentosOriginal = <FoodModel>[];

  // 3. O dia atual deve ser um Rx ou ser calculado na UI, mas manter como final para simplicidade.
  final dayNow = FormatterHelper.formatDate();

  // --- ESTADO DE SELEÇÃO E COMPRA ---
  final sizeSelected = Rxn<String>(); // O tamanho selecionado
  final foodSelect = Rxn<FoodModel>(); // O alimento selecionado

  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;

  // --- GETTERS ---
  FoodModel? get selectedFood => foodSelect.value;
  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;

  LunchboxesController({
    required LunchboxesServices lunchboxesServices,
    required CarrinhoServices carrinhoServices,
  })  : _lunchboxesServices = lunchboxesServices,
        _carrinhoServices = carrinhoServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
    ever<int>(_quantity, (quantity) {
      _totalPrice(selectedFood?.pricePerSize[sizeSelected.value]);
    });
  }

  @override
  void onReady() async {
    super.onReady();
    await getLunchboxes();
  }

  Future<void> getLunchboxes() async {
    try {
      _loading(true);
      final menuData = await _lunchboxesServices.getMenu();
      final alimentosData = await _lunchboxesServices.getFood();

      final List<String> sizesList = List<String>.from(menuData.first.pricePerSize);

      availableSizes.assignAll(sizesList);
      _availableSizesOriginal
        ..clear()
        ..addAll(sizesList);

      final filtered = alimentosData.where((e) => e.dayName == dayNow);

      alimentos.assignAll(filtered);
      _alimentosOriginal
        ..clear()
        ..addAll(filtered);
      _loading.toggle();
    } catch (e, s) {
      _loading(false);
      log('Erro ao carregar marmitas', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao carregar marmitas',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading(false);
    }
  }

  void filterPrice(String selectedSize) {
    try {
      // _loading(true);

      if (sizeSelected.value == selectedSize) {
        sizeSelected.value = '';
        availableSizes.assignAll(_availableSizesOriginal);
        return;
      }

      sizeSelected.value = selectedSize;

      final filtered = _alimentosOriginal.where((alimento) {
        return alimento.pricePerSize.containsKey((selectedSize));
      }).toList();

      availableSizes.assignAll(
          filtered.map((e) => e.pricePerSize.keys.toList()).expand((e) => e).toSet().toList());
    } catch (e, s) {
      _loading(false);
      log('Erro ao filtar marmitas', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao filtrar marmitas',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading(false);
    }
  }

  void addFood() {
    _quantity.value++;
  }

  void removeFood() {
    if (_quantity.value > 0) _quantity.value--;
  }

  void setFoodSelected(FoodModel food) {
    foodSelect.value = food;

    final carrinhoItem = _carrinhoServices.getById(food.id);
    if (carrinhoItem != null) {
      _quantity(carrinhoItem.item.quantidade);
      _alreadyAdded(true);
    } else {
      _quantity(1);
      _alreadyAdded(false);
    }
  }

  void addFoodShoppingCard() {
    final selected = selectedFood;

    if (selected == null) {
      _alreadyAdded.value = false;
      return;
    }

    log('ALIMENTO SELECIONADO: ${selected.name}');
    _carrinhoServices.addOrUpdateFood(
      selected,
      quantity: _quantity.value,
      selectedSize: sizeSelected.value ?? '',
    );
    Get.back();
  }
}
