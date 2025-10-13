import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';

import './lunchboxes_services.dart';

class LunchboxesServicesImpl implements LunchboxesServices {
  final LunchboxesRepository _lunchboxesRepository;

  LunchboxesServicesImpl({required LunchboxesRepository lunchboxesRepository})
      : _lunchboxesRepository = lunchboxesRepository;

  @override
  Future<List<AlimentoModel>> getFood() => _lunchboxesRepository.getFood();

  @override
  Future<List<MenuModel>> getMenu() => _lunchboxesRepository.getMenu();

  @override
  Future<List<MenuModel>> getData() => _lunchboxesRepository.getData();
}
