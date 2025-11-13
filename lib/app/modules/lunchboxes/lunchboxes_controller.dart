import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/food_service.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;
  final CarrinhoServices _carrinhoServices;
  final FoodService _foodService;
  final AuthService _authService;

  // --- ESTADO REATIVO CENTRALIZADO ---
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  // --- DADOS PRINCIPAIS E BACKUPS ---
  final availableSizes = <String>[].obs;
  final _availableSizesOriginal = <String>[];

  RxList<FoodModel> get alimentos => _foodService.alimentos;
  final alimentosFiltrados = <FoodModel>[].obs;

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
    required FoodService foodService,
    required AuthService authService,
  })  : _lunchboxesServices = lunchboxesServices,
        _carrinhoServices = carrinhoServices,
        _foodService = foodService,
        _authService = authService;

  bool get admin => _authService.isAdmin();
  void updateListFoods(int id, FoodModel food) => _foodService.updateTemHoje(id, food);

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    ever<int>(_quantity, (quantity) {
      _totalPrice(selectedFood?.pricePerSize[sizeSelected.value]);
    });

    ever<List<FoodModel>>(alimentos, (_) {
      alimentos.where((e) => e.temHoje).toList();
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
      final List<String> sizesList = List<String>.from(menuData.first.pricePerSize);

      availableSizes.assignAll(sizesList);
      _availableSizesOriginal
        ..clear()
        ..addAll(sizesList);

      _foodService.refreshFood();
      _loading(false);
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
      if (sizeSelected.value == selectedSize) {
        sizeSelected.value = '';
        availableSizes.assignAll(_availableSizesOriginal);
        return;
      }

      sizeSelected.value = selectedSize;

      final filtered = alimentos.where((alimento) {
        return alimento.pricePerSize.containsKey((selectedSize));
      }).toList();

      availableSizes.assignAll(
        filtered
            .map(
              (e) => e.pricePerSize.keys.toList(),
            )
            .expand(
              (e) => e,
            )
            .toSet()
            .toList(),
      );
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

  void removeAllFoodsUnit() {
    _quantity.value = 0;
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
      _alreadyAdded(false);
      return;
    }

    _carrinhoServices.addOrUpdateFood(
      selected,
      quantity: _quantity.value,
      selectedSize: sizeSelected.value ?? '',
    );
    log('QUANTIDADE ENVIADA : $quantity');
    Get.close(0);
  }

  Future<void> refreshLunchboxes() async {
    try {
      await getLunchboxes();
    } catch (e, s) {
      log('Erro ao atualizar marmitas', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao atualizar marmitas',
          type: MessageType.error,
        ),
      );
    }
  }
}
