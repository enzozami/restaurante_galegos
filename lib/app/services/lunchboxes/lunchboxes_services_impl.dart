import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';

import './lunchboxes_services.dart';

class LunchboxesServicesImpl extends GetxService implements LunchboxesServices {
  final LunchboxesRepository _lunchboxesRepository;

  final _alimentos = <FoodModel>[].obs;
  final _times = <TimeModel>[].obs;

  final TimeServices _timeServices;

  LunchboxesServicesImpl({
    required LunchboxesRepository lunchboxesRepository,
    required TimeServices timeServices,
  }) : _lunchboxesRepository = lunchboxesRepository,
       _timeServices = timeServices;

  @override
  RxList<FoodModel> get alimentos => _alimentos;

  @override
  RxList<TimeModel> get times => _times;

  @override
  Future<LunchboxesServices> init() async {
    await refreshTime();
    await refreshFood();
    return this;
  }

  @override
  Future<List<FoodModel>> getFood() => _lunchboxesRepository.getFood();

  @override
  Future<List<MenuModel>> getMenu() => _lunchboxesRepository.getMenu();

  @override
  Future<FoodModel> cadastrarMarmita(
    String name,
    List<String> days,
    String? description,
    Map<String, double> prices,
  ) async {
    final marmita = _criarFood(name, days, description, prices);
    return await _lunchboxesRepository.cadastrarMarmita(marmita);
  }

  @override
  Future<void> deletarMarmita(FoodModel food) async {
    await _lunchboxesRepository.deletarMarmita(food);
    await refreshFood();
  }

  @override
  Future<void> updateTemHoje(int id, FoodModel food) async {
    final novoValor = !food.temHoje;
    await _lunchboxesRepository.updateTemHoje(id, food, novoValor);

    final index = _alimentos.indexWhere((e) => e.id == id);
    if (index != -1) {
      _alimentos.value[index] = alimentos[index].copyWith(temHoje: novoValor);
    }
  }

  FoodModel _criarFood(
    String name,
    List<String> days,
    String? description,
    Map<String, double> prices,
  ) {
    return FoodModel(
      id: (alimentos.isEmpty ? 1 : alimentos.value.last.id + 1),
      name: name,
      temHoje: true,
      dayName: days,
      description: description ?? '',
      pricePerSize: prices,
      image: '',
    );
  }

  Future<void> refreshFood() async {
    _alimentos.assignAll(await getFood());
  }

  Future<void> refreshTime() async {
    _times.assignAll(await _timeServices.getTime());
  }
}
