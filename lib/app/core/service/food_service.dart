import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';

class FoodService extends GetxService {
  final LunchboxesServices _lunchboxesServices;
  final alimentos = <FoodModel>[].obs;
  final dayNow = FormatterHelper.formatDate();

  FoodService({
    required LunchboxesServices lunchboxesServices,
  }) : _lunchboxesServices = lunchboxesServices;

  Future<FoodService> init() async {
    await refreshFood();
    return this;
  }

  Future<void> refreshFood() async {
    final data = await _lunchboxesServices.getFood();
    final filtered = data.where((e) => e.dayName.contains(dayNow));
    alimentos.assignAll(filtered);
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
}
