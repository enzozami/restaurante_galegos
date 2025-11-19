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

enum FoodSize { mini, media }

extension FoodSizeKey on FoodSize {
  String get key {
    switch (this) {
      case FoodSize.mini:
        return 'mini';
      case FoodSize.media:
        return 'media';
    }
  }
}

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;
  final CarrinhoServices _carrinhoServices;
  final FoodService _foodService;
  final AuthService _authService;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  // tamanhos disponíveis vindos do servidor
  final RxList<String> availableSizes = <String>[].obs;

  // seleção atual
  final sizeSelected = Rxn<FoodSize>();
  final foodSelected = Rxn<FoodModel>();

  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;

  final RxList<String> addDays = <String>[].obs;
  final daysSelected = Rxn<String>();

  final String dayNow = FormatterHelper.formatDate();

  LunchboxesController({
    required LunchboxesServices lunchboxesServices,
    required CarrinhoServices carrinhoServices,
    required FoodService foodService,
    required AuthService authService,
  }) : _lunchboxesServices = lunchboxesServices,
       _carrinhoServices = carrinhoServices,
       _foodService = foodService,
       _authService = authService;

  // getters simplificados
  RxList<FoodModel> get alimentos => _foodService.alimentos;
  RxList<TimeModel> get times => _foodService.times;
  FoodModel? get selectedFood => foodSelected.value;

  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;

  bool get admin => _authService.isAdmin();

  @override
  Future<void> onInit() async {
    super.onInit();

    loaderListener(_loading);
    messageListener(_message);

    await getLunchboxes();

    ever(_quantity, (_) => _updateTotalPrice());
  }

  // ------------------------
  // LÓGICA DE CÁLCULO
  // ------------------------
  void _updateTotalPrice() {
    final food = selectedFood;
    final size = sizeSelected.value;

    if (food == null || size == null) {
      _totalPrice(0);
      return;
    }

    final price = food.pricePerSize[size.key] ?? 0;
    _totalPrice(price * quantity);
  }

  // ------------------------
  // LÓGICA DE FILTRO
  // ------------------------
  List<FoodModel> get alimentosFiltrados {
    final size = sizeSelected.value;
    final day = daysSelected.value;

    return alimentos.where((food) {
      final matchSize = size == null ? true : food.pricePerSize.containsKey(size.key);

      final matchDay = day == null ? true : food.dayName.contains(day);

      return matchSize && matchDay;
    }).toList();
  }

  void filterSize(FoodSize newSize) {
    sizeSelected.value = (sizeSelected.value == newSize) ? null : newSize;
  }

  void filterByDay(String? day) {
    daysSelected.value = (daysSelected.value == day) ? null : day;
  }

  // ------------------------
  // LÓGICA DE SELEÇÃO E COMPRA
  // ------------------------
  void addFood() => _quantity.value++;
  void removeFood() {
    if (_quantity.value > 0) _quantity.value--;
  }

  void removeAllFoodsUnit() => _quantity.value = 0;

  void setFoodSelected(FoodModel food) {
    foodSelected.value = food;

    final item = _carrinhoServices.getById(food.id);
    if (item != null) {
      _quantity(item.item.quantidade);
      _alreadyAdded(true);
    } else {
      _quantity(1);
      _alreadyAdded(false);
    }

    _updateTotalPrice();
  }

  void addFoodShoppingCard() {
    final food = selectedFood;
    final size = sizeSelected.value;

    if (food == null || size == null) {
      _alreadyAdded(false);
      return;
    }

    _carrinhoServices.addOrUpdateFood(food, quantity: quantity, selectedSize: size.key);

    Get.close(0);
  }

  // ------------------------
  // LÓGICA DE CADASTRO
  // ------------------------
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

    _foodService.cadastrarM(name, addDays, description, {'mini': priceMini, 'media': priceMedia});
  }

  // ------------------------
  // CARREGAMENTO DO MENU
  // ------------------------
  Future<void> getLunchboxes() async {
    try {
      _loading(true);

      final menuData = await _lunchboxesServices.getMenu();

      // menuData.first.pricePerSize é um Map<String, double>
      availableSizes.assignAll(menuData.first.pricePerSize);

      _foodService.init();
    } catch (e, s) {
      log('Erro ao carregar marmitas', error: e, stackTrace: s);
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao carregar marmitas', type: MessageType.error),
      );
    } finally {
      _loading(false);
    }
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

  void updateListFoods(int id, FoodModel food) {
    _foodService.updateTemHoje(id, food);
  }
}
