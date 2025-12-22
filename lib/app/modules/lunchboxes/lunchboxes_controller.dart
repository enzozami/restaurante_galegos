import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/dialogs/alert_products_lunchboxes_adm.dart';
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
  final availableSizes = <String>[].obs;
  final foodSelect = Rxn<FoodModel>();
  final sizeSelected = Rxn<String>();
  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;
  final RxList<String> addDays = <String>[].obs;
  final daysSelected = Rxn<String>();
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
      await 500.milliseconds.delay();
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
      await 500.milliseconds.delay();
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao atualizar marmitas',
          type: MessageType.error,
        ),
      );
    }
  }

  Future<void> atualizarMarmitasDoDia(int id, FoodModel food) =>
      _foodService.updateTemHoje(id, food);

  void cadastrarNovasMarmitas() {
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
    if (!validateForm()) return;
    _foodService.cadastrarMarmita(
      nomeMarmitaEC.text,
      addDays,
      descricaoEC.text,
      {
        'mini': double.parse(
          precoMiniEC.text.replaceAll('.', '').replaceAll(',', '.'),
        ),
        'media': double.parse(
          precoMediaEC.text.replaceAll('.', '').replaceAll(',', '.'),
        ),
      },
    );
    nomeMarmitaEC.clear();
    descricaoEC.clear();
    precoMiniEC.clear();
    precoMediaEC.clear();
    addDays.clear();
    refreshLunchboxes();
    Get.back();
  }

  Future<void> atualizarDadosDaMarmita(FoodModel alimento) async {
    try {
      _loading.value = true;
      final temHoje = alimentoTemHoje(alimento);
      final RxBool novoTemHoje = temHoje.value.obs;
      if (novoTemHoje.value != temHoje.value) {
        temHoje.value = novoTemHoje.value;
        await atualizarMarmitasDoDia(alimento.id, alimento);
        await refreshLunchboxes();
      }
      if (validateForm()) {
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
        final cleanedMini = newPriceMiniEC.text.replaceAll('.', '').replaceAll(',', '.');
        final cleanedMedia = newPriceMediaEC.text.replaceAll('.', '').replaceAll(',', '.');
        await _foodService.updateData(
          alimento.id,
          newNameEC.text,
          newDescriptionEC.text,
          addDays,
          {
            'mini': double.parse(cleanedMini),
            'media': double.parse(cleanedMedia),
          },
        );
        await refreshLunchboxes();
        Get.back();
      } else if (novoTemHoje.value != temHoje.value) {
        Get.back();
      }
    } catch (e) {
      _loading.value = false;
      await 500.milliseconds.delay();
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao atualizar marmita',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading.value = false;
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
      await 250.milliseconds.delay();
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
    final temHoje = alimentoTemHoje(alimento);
    final RxBool novoTemHoje = temHoje.value.obs;
    Future<void> onPressedFunction() async {
      await atualizarDadosDaMarmita(alimento);
      Get.back();
    }

    onChangedSelectionFunction(
      List<Object?> allSelectedItems,
      Object? selectedItem,
    ) {
      alimento.dayName = allSelectedItems.cast<String>();
      addDays.value = allSelectedItems.map((e) => e as String).toList();
    }

    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertProductsLunchboxesAdm(
            isProduct: false,
            onPressed: onPressedFunction,
            description: newDescriptionEC,
            value: novoTemHoje,
            onChanged: (bool value) async {
              novoTemHoje.value = value;
            },
            nameFood: newNameEC,
            priceMini: newPriceMiniEC,
            priceMedia: newPriceMediaEC,
            items: times
                .expand((d) => d.days)
                .map(
                  (e) => MultiSelectCard<String>(
                    value: e,
                    label: e[0],
                    selected: alimento.dayName.contains(e),
                  ),
                )
                .toList(),
            onChangedSection: onChangedSelectionFunction,
          ),
        );
      },
    );
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
}
