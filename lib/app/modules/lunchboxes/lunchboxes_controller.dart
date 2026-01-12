import 'dart:developer';

import 'package:flutter/material.dart';
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

  LunchboxesController({
    required LunchboxesServices lunchboxesServices,
    required CarrinhoServices carrinhoServices,
    required LunchboxesServices foodService,
    required AuthServices authServices,
  }) : _lunchboxesServices = lunchboxesServices,
       _carrinhoServices = carrinhoServices,
       _foodService = foodService,
       _authServices = authServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final isProcessing = false.obs;
  final RxnInt pressingItemId = RxnInt();
  final availableSizes = <String>[].obs;
  final foodSelect = Rxn<FoodModel>();
  final sizeSelected = Rxn<String>();
  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;
  final RxList<String> addDays = <String>[].obs;
  final daysSelected = Rxn<String>();
  final daysPressing = Rxn<String>();
  final _availableSizesOriginal = <String>[];
  final dayNow = FormatterHelper.formatDate();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nomeMarmitaEC = TextEditingController();
  final TextEditingController descricaoEC = TextEditingController();
  final TextEditingController precoMiniEC = TextEditingController();
  final TextEditingController precoMediaEC = TextEditingController();
  final TextEditingController newNameEC = TextEditingController();
  final TextEditingController newDescriptionEC = TextEditingController();
  final TextEditingController newPriceMiniEC = TextEditingController();
  final TextEditingController newPriceMediaEC = TextEditingController();

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

  @override
  void onClose() {
    nomeMarmitaEC.dispose();
    descricaoEC.dispose();
    precoMediaEC.dispose();
    precoMiniEC.dispose();
    newNameEC.dispose();
    newDescriptionEC.dispose();
    newPriceMiniEC.dispose();
    newPriceMediaEC.dispose();
    super.onClose();
  }

  Future<void> _getLunchboxes() async {
    try {
      _loading.value = true;
      final menuData = await _lunchboxesServices.getMenu();
      final List<String> sizesList = List<String>.from(
        menuData.first.pricePerSize,
      );
      availableSizes.assignAll(sizesList);
      _availableSizesOriginal
        ..clear()
        ..addAll(sizesList);
      await _foodService.init();
    } catch (e, s) {
      log('Erro ao carregar marmitas', error: e, stackTrace: s);
      _loading.value = false;
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao carregar marmitas',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading.value = false;
    }
  }

  Future<void> refreshLunchboxes() async {
    try {
      await _getLunchboxes();
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

  Future<void> apagarMarmita(FoodModel food) => _foodService.deletarMarmita(food);

  void filtrarPreco(String selectedSize) {
    if (sizeSelected.value == selectedSize) {
      sizeSelected.value = '';
      return;
    }
    sizeSelected.value = selectedSize;
  }

  Future<void> filtrarPorDia(String? day) async {
    try {
      _loading.value = true;
      if (day == daysSelected.value) {
        daysSelected.value = null;
        return;
      }
      daysSelected.value = day;
    } finally {
      _loading.value = false;
    }
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

  RxBool alimentoTemHoje(FoodModel a) => RxBool(a.temHoje);

  bool validateForm() => formKey.currentState?.validate() ?? false;

  void handleFoodTap(BuildContext context, FoodModel alimento, String size) {
    definirComidaSelecionada(alimento, size);

    Get.toNamed('/admin/detail/lunchboxes', arguments: alimento);
  }

  Future<bool> exibirConfirmacaoDescarte(
    BuildContext context,
    FoodModel alimento,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final ThemeData theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            'ATENÇÃO',
            textAlign: .center,
            style: theme.textTheme.titleMedium,
          ),
          content: Text(
            'Deseja excluir essa marmita?',
            textAlign: .center,
            style: theme.textTheme.bodySmall,
          ),
          actionsAlignment: .center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: theme.elevatedButtonTheme.style,
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: theme.elevatedButtonTheme.style,
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
    return confirm == true;
  }

  void handlePress(int? id) {
    pressingItemId.value = id;
  }

  void handlePressFilter(String? d) {
    daysPressing.value = d;
  }
}
