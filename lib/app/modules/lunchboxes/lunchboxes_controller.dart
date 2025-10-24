import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/shopping/shopping_card_services.dart';

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;
  final ShoppingCardServices _shoppingCardServices;

  // --- ESTADO REATIVO CENTRALIZADO ---
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  // --- DADOS PRINCIPAIS E BACKUPS ---
  // Renomear para 'availableSizes' para clareza
  final availableSizes = <String>[].obs;
  final _availableSizesOriginal = <String>[];

  final alimentos = <AlimentoModel>[].obs;
  final _alimentosOriginal = <AlimentoModel>[];

  // 3. O dia atual deve ser um Rx ou ser calculado na UI, mas manter como final para simplicidade.
  final dayNow = FormatterHelper.formatDate();

  // --- ESTADO DE SELEÇÃO E COMPRA ---
  final sizeSelected = Rxn<String>(); // O tamanho selecionado
  final foodSelect = Rxn<AlimentoModel>(); // O alimento selecionado

  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;

  // --- GETTERS ---
  AlimentoModel? get selectedFood => foodSelect.value;
  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;

  LunchboxesController({
    required LunchboxesServices lunchboxesServices,
    required ShoppingCardServices shoppingCardServices,
  })  : _lunchboxesServices = lunchboxesServices,
        _shoppingCardServices = shoppingCardServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() async {
    super.onReady();
    ever<AlimentoModel?>(foodSelect, (alimento) {
      if (alimento != null) {
        final size = sizeSelected.value;
        final list = _shoppingCardServices.productsSelected
            .where((element) => element.food?.id == alimento.id);

        if (list.isNotEmpty) {
          final foodList = list.map((e) => e.food?.id).toList();

          if (foodList.isNotEmpty && foodList.contains(alimento.id)) {
            _quantity(list.first.quantity);
            final price = alimento.pricePerSize[size];
            if (price != null) {
              _totalPrice(price * _quantity.value);
            }
          }
        }
      } else {
        _alreadyAdded(false);
        _quantity(1);
      }
    });
    await getLunchboxes();
  }

  Future<void> getLunchboxes() async {
    try {
      _loading.toggle();
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
      _loading.toggle();
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
      _loading.toggle();
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
      _loading.toggle();
    } catch (e, s) {
      _loading.toggle();
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

  void addFoodShoppingCard() {
    final selected = selectedFood;

    if (selected == null) {
      _alreadyAdded.value = false;
      return;
    }

    log('ALIMENTO SELECIONADO: ${selected.name}');
    _shoppingCardServices.addOrUpdateFood(
      selected,
      quantity: quantity,
      selectedSize: sizeSelected.value ?? '',
    );
    Get.back();
  }
}
