import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/food_service.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';
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
  final isProcessing = false.obs;

  // --- DADOS PRINCIPAIS E BACKUPS ---
  final availableSizes = <String>[].obs;
  final _availableSizesOriginal = <String>[];

  RxList<FoodModel> get alimentos => _foodService.alimentos;
  RxList<TimeModel> get times => _foodService.times;
  // final alimentosFiltrados = <FoodModel>[].obs;

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
  }) : _lunchboxesServices = lunchboxesServices,
       _carrinhoServices = carrinhoServices,
       _foodService = foodService,
       _authService = authService;

  bool get admin => _authService.isAdmin();
  void updateListFoods(int id, FoodModel food) => _foodService.updateTemHoje(id, food);

  final RxList<String> addDays = <String>[].obs;
  final daysSelected = Rxn<String>();

  List<FoodModel> get alimentosFiltrados {
    final size = sizeSelected.value;
    final day = daysSelected.value;

    return alimentos
        .where((food) {
          final matchSize = size == null || size.isEmpty
              ? true
              : food.pricePerSize.containsKey(size);

          final matchDay = day == null || day.isEmpty ? true : food.dayName.contains(day);

          return matchSize && matchDay;
        })
        .toSet()
        .toList();
  }

  void cadastrar(String name, String? description, double priceMini, double priceMedia) {
    if (addDays.isEmpty) {
      _message(
        MessageModel(
          title: 'Atenção',
          message: 'Selecione ao menos um dia para cadastrar.',
          type: MessageType.error,
        ),
      );
      return;
    }
    log("DEBUG: função de salvar foi chamada");
    _foodService.cadastrarM(name, addDays, description, {'mini': priceMini, 'media': priceMedia});
    log(" função de salvar foi chamada");
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
    await getLunchboxes();

    ever<int>(_quantity, (quantity) {
      _totalPrice(selectedFood?.pricePerSize[sizeSelected.value]);
    });

    ever<List<FoodModel>>(alimentos, (_) {
      alimentos.where((e) => e.temHoje).toList();
    });
  }

  Future<void> getLunchboxes() async {
    try {
      final menuData = await _lunchboxesServices.getMenu();
      final List<String> sizesList = List<String>.from(menuData.first.pricePerSize);

      availableSizes.assignAll(sizesList);
      _availableSizesOriginal
        ..clear()
        ..addAll(sizesList);

      _foodService.init();
    } catch (e, s) {
      _loading(false);
      log('Erro ao carregar marmitas', error: e, stackTrace: s);
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao carregar marmitas', type: MessageType.error),
      );
    } finally {
      _loading(false);
    }
  }

  void filterPrice(String selectedSize) {
    if (selectedSize == sizeSelected.value) {
      sizeSelected.value = '';
      return;
    }
    sizeSelected.value = selectedSize;
  }

  void filterByDay(String? day) {
    if (day == daysSelected.value) {
      daysSelected.value = null;
      return;
    }
    daysSelected.value = day;
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
        MessageModel(title: 'Erro', message: 'Erro ao atualizar marmitas', type: MessageType.error),
      );
    }
  }
}
