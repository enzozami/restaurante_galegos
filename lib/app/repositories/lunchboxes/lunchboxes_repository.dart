import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';

abstract interface class LunchboxesRepository {
  Future<List<MenuModel>> getMenu();
  Future<List<AlimentoModel>> getFood();
  // Future<List<MenuModel>> getDays();
}
