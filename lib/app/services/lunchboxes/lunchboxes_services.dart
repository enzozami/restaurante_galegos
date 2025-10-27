import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';

abstract interface class LunchboxesServices {
  Future<List<FoodModel>> getFood();
  Future<List<MenuModel>> getMenu();
}
