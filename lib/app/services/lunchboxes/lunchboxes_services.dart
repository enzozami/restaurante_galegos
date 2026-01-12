import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';

abstract interface class LunchboxesServices {
  RxList<FoodModel> get alimentos;
  RxList<TimeModel> get times;
  Future<LunchboxesServices> init();

  Future<List<FoodModel>> getFood();
  Future<List<MenuModel>> getMenu();
  Future<FoodModel> cadastrarMarmita({
    required String name,
    required List<String> days,
    required String? description,
    required Map<String, double> prices,
  });
  Future<void> deletarMarmita(FoodModel food);
  Future<void> updateData({
    required FoodModel food,
    required String? newName,
    required String? newDescription,
    required List<String>? newDays,
    required Map<String, double>? newPrices,
    required bool? newTemHoje,
  });
  Future<void> refreshData();
}
