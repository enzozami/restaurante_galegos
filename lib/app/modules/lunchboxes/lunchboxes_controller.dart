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
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final sizes = <String>[].obs;
  final _sizesOriginal = <String>[];

  final alimentos = <AlimentoModel>[].obs;
  final _alimentosOriginal = <AlimentoModel>[];

  final dayNow = FormatterHelper.formatDate();

  final sizeSelected = Rxn<String>();

  // SHOPPING CARD
  final ShoppingCardServices _shoppingCardServices;
  final foodSelect = Rxn<AlimentoModel>();
  AlimentoModel? get productsSelected => foodSelect.value;

  final _quantity = 1.obs;
  int get quantity => _quantity.value;
  final _alreadyAdded = false.obs;
  bool get alreadyAdded => _alreadyAdded.value;

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
    await getLunchboxes();
  }

  Future<void> getLunchboxes() async {
    try {
      _loading.toggle();
      final menuData = await _lunchboxesServices.getMenu();
      final alimentosData = await _lunchboxesServices.getFood();

      final List<String> sizesList = List<String>.from(menuData.first.pricePerSize);

      sizes.assignAll(sizesList);
      _sizesOriginal
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
        sizes.assignAll(_sizesOriginal);
        return;
      }

      sizeSelected.value = selectedSize;

      final filtered = _alimentosOriginal.where((alimento) {
        return alimento.pricePerSize.containsKey((selectedSize));
      }).toList();

      sizes.assignAll(
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
    _shoppingCardServices.addOrUpdateFood(
      productsSelected,
      quantity: quantity,
      selectedSize: sizeSelected.value ?? '',
    );
    _quantity.value = 1;
    Get.back();
  }
}
