import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';

import './lunchboxes_services.dart';

class LunchboxesServicesImpl implements LunchboxesServices {
  final LunchboxesRepository _lunchboxesRepository;

  LunchboxesServicesImpl({required LunchboxesRepository lunchboxesRepository})
    : _lunchboxesRepository = lunchboxesRepository;

  @override
  Future<List<FoodModel>> getFood() => _lunchboxesRepository.getFood();

  @override
  Future<List<MenuModel>> getMenu() => _lunchboxesRepository.getMenu();

  @override
  Future<void> updateTemHoje(int id, FoodModel food, bool novoValor) =>
      _lunchboxesRepository.updateTemHoje(id, food, novoValor);

  @override
  Future<FoodModel> cadastrarMarmita(FoodModel food) =>
      _lunchboxesRepository.cadastrarMarmita(food);

  @override
  Future<void> deletarMarmita(FoodModel food) => _lunchboxesRepository.deletarMarmita(food);
}
