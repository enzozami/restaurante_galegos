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
  Future<FoodModel> cadastrarMarmita(
    String name,
    List<String> days,
    String? description,
    Map<String, double> prices,
  );
  Future<void> deletarMarmita(FoodModel food);
  Future<void> updateTemHoje(int id, FoodModel food);
}
