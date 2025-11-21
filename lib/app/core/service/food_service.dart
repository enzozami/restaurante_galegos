import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';

class FoodService extends GetxService {
  final LunchboxesServices _lunchboxesServices;
  final alimentos = <FoodModel>[].obs;
  final dayNow = FormatterHelper.formatDate();
  final TimeServices _timeServices;
  final times = <TimeModel>[].obs;

  FoodService({required LunchboxesServices lunchboxesServices, required TimeServices timeServices})
    : _lunchboxesServices = lunchboxesServices,
      _timeServices = timeServices;

  Future<FoodService> init() async {
    await horarios();
    await refreshFood();
    return this;
  }

  Future<void> refreshFood() async {
    final data = await _lunchboxesServices.getFood();
    alimentos.assignAll(data);
  }

  Future<void> updateTemHoje(int id, FoodModel food) async {
    final novoValor = !food.temHoje;
    await _lunchboxesServices.updateTemHoje(id, food, novoValor);

    final index = alimentos.indexWhere((e) => e.id == id);
    if (index != -1) {
      alimentos[index] = alimentos[index].copyWith(temHoje: novoValor);
      alimentos.refresh();
    }
  }

  Future<void> cadastrarM(
    String name,
    List<String> days,
    String? description,
    Map<String, double> prices,
  ) async {
    final food = FoodModel(
      id: (alimentos.value.last.id + 1),
      name: name,
      temHoje: true,
      dayName: days,
      image: '',
      description: description ?? 'Acompanha arroz, feijão, 1 mistura e 2 acompanhamentos',
      pricePerSize: prices,
    );

    _lunchboxesServices.cadastrarMarmita(food);
    refreshFood();
  }

  Future<void> horarios() async {
    final result = await _timeServices.getTime();
    times.value = result;
  }
}
