import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;
  final CarrinhoServices _carrinhoServices;
  final LunchboxesServices _foodService;
  final AuthServices _authServices;

  final dayNow = FormatterHelper.formatDate();

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final isProcessing = false.obs;
  final availableSizes = <String>[].obs;
  final foodSelect = Rxn<FoodModel>(); // O alimento selecionado
  final sizeSelected = Rxn<String>(); // O tamanho selecionado
  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;
  final RxList<String> addDays = <String>[].obs;
  final daysSelected = Rxn<String>();

  final _availableSizesOriginal = <String>[];

  RxBool get loading => _loading;
  RxList<FoodModel> get alimentos => _foodService.alimentos;
  RxList<TimeModel> get times => _foodService.times;
  FoodModel? get selectedFood => foodSelect.value;
  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;
  bool get admin => _authServices.isAdmin();
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

  LunchboxesController({
    required LunchboxesServices lunchboxesServices,
    required CarrinhoServices carrinhoServices,
    required LunchboxesServices foodService,
    required AuthServices authServices,
  }) : _lunchboxesServices = lunchboxesServices,
       _carrinhoServices = carrinhoServices,
       _foodService = foodService,
       _authServices = authServices;

  @override
  Future<void> onInit() async {
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
  Future<void> onReady() async {
    super.onReady();
    await _getLunchboxes();
  }

  Future<void> _getLunchboxes() async {
    try {
      _loading.value = true;
      final menuData = await _lunchboxesServices.getMenu();
      final List<String> sizesList = List<String>.from(menuData.first.pricePerSize);

      availableSizes.assignAll(sizesList);
      _availableSizesOriginal
        ..clear()
        ..addAll(sizesList);

      _foodService.init();
    } catch (e, s) {
      log('Erro ao carregar marmitas', error: e, stackTrace: s);
      _loading.value = false;
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao carregar marmitas', type: MessageType.error),
      );
    } finally {
      _loading.value = false;
    }
  }

  Future<void> atualizarMarmitasDoDia(int id, FoodModel food) =>
      _foodService.updateTemHoje(id, food);

  void cadastrarNovasMarmitas(
    String name,
    String? description,
    double priceMini,
    double priceMedia,
  ) {
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
    _foodService.cadastrarMarmita(name, addDays, description, {
      'mini': priceMini,
      'media': priceMedia,
    });
    log(" função de salvar foi chamada");
  }

  void filtrarPreco(String selectedSize) {
    if (sizeSelected.value == selectedSize) {
      sizeSelected.value = '';
      return;
    }

    sizeSelected.value = selectedSize;
  }

  void filtrarPorDia(String? day) {
    if (day == daysSelected.value) {
      daysSelected.value = null;
      return;
    }
    daysSelected.value = day;
  }

  void adicionarQuantidade() {
    _quantity.value++;
  }

  void removerQuantidade() {
    if (_quantity.value > 0) _quantity.value--;
  }

  void definirComidaSelecionada(FoodModel food, String size) {
    foodSelect.value = food;

    final carrinhoItem = _carrinhoServices.getByIdAndSize(food.id, size);
    if (carrinhoItem != null && carrinhoItem.tamanho == size) {
      _quantity(carrinhoItem.quantidade);
      _alreadyAdded(true);
    } else {
      _quantity(1);
      _alreadyAdded(false);
    }
  }

  void adicionarMarmitaAoCarrinho() {
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
    sizeSelected.value = '';
    Get.close(0);
  }

  Future<void> refreshLunchboxes() async {
    try {
      _getLunchboxes();
    } catch (e, s) {
      log('Erro ao atualizar marmitas', error: e, stackTrace: s);
      _loading.value = false;
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao atualizar marmitas', type: MessageType.error),
      );
    }
  }

  Future<void> apagarMarmita(FoodModel food) => _foodService.deletarMarmita(food);

  Future<void> atualizarDadosDaMarmita(
    int id,
    String newName,
    String? newDescription,
    double priceMini,
    double priceMedia,
  ) async {
    try {
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
      await _foodService.updateData(id, newName, newDescription, addDays, {
        'mini': priceMini,
        'media': priceMedia,
      });
      await refreshLunchboxes();
    } catch (e) {
      _loading.value = false;
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao atualizar marmita', type: MessageType.error),
      );
    } finally {
      _loading.value = false;
    }
  }

  RxBool temHoje(FoodModel a) => RxBool(a.temHoje);
}
