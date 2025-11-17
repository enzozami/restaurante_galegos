import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';

abstract interface class LunchboxesRepository {
  Future<List<FoodModel>> getFood();
  Future<List<MenuModel>> getMenu();
  Future<void> updateTemHoje(int id, FoodModel food, bool novoValor);
  Future<FoodModel> cadastrarMarmita(FoodModel food);
}
