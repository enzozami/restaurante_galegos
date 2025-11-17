import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/food_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';

import './lunchboxes_repository.dart';

class LunchboxesRepositoryImpl implements LunchboxesRepository {
  final RestClient _restClient;

  LunchboxesRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<List<FoodModel>> getFood() async {
    final result = await _restClient.get('/alimentos');

    if (result.hasError) {
      log('Erro ao buscar alimentos', error: result.statusText);
      throw Exception('Erro ao buscar alimentos');
    }

    final data = List<Map<String, dynamic>>.from(result.body);

    final alimentos = data.map((e) => FoodModel.fromMap(e)).toList();

    return alimentos;
  }

  @override
  Future<List<MenuModel>> getMenu() async {
    final result = await _restClient.get('/menu');

    if (result.hasError) {
      log('Erro ao buscar menu', error: result.statusText);
      RestClientException(message: 'Erro ao buscar marmitas');
    }

    final List data = (result.body as List);

    final menuList = data.map((d) => MenuModel.fromMap(d)).toList();

    return menuList;
  }

  @override
  Future<void> updateTemHoje(int id, FoodModel food, bool novoValor) async {
    final result = await _restClient.put('/alimentos/$id', {
      'temHoje': novoValor,
    });
    if (result.hasError) {}
  }

  @override
  Future<FoodModel> cadastrarMarmita(FoodModel food) async {
    final result = await _restClient.post('/alimentos', {
      'name': food.name,
      'id': food.id,
      'dayName': food.dayName,
      'temHoje': food.temHoje,
      'description': food.description,
      'pricePerSize': food.pricePerSize,
    });

    if (result.hasError) {
      log(
        'Erro ao cadastrar novo produto',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      RestClientException(message: 'Erro ao cadastrar nova marmita');
    }

    return FoodModel.fromMap(result.body);
  }
}
