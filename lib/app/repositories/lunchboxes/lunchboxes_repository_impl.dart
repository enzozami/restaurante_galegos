import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';

import './lunchboxes_repository.dart';

class LunchboxesRepositoryImpl implements LunchboxesRepository {
  final RestClient _restClient;

  LunchboxesRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<List<AlimentoModel>> getFood() async {
    final result = await _restClient.get('/alimentos');

    if (result.hasError) {
      log('Erro ao buscar alimentos', error: result.statusText);
      throw Exception('Erro ao buscar alimentos');
    }

    final data = List<Map<String, dynamic>>.from(result.body);

    log('Buscando alimentos: $data');

    final alimentos = data.map((e) => AlimentoModel.fromMap(e)).toList();

    log('ALIMENTOS: $alimentos');

    return alimentos;
  }

  @override
  Future<List<MenuModel>> getMenu() async {
    final result = await _restClient.get('/menu');

    log('MENU RESPONSE: ${result.body}');

    if (result.hasError) {
      log('Erro ao buscar menu', error: result.statusText);
      throw Exception('Erro ao buscar menu');
    }

    final List data = (result.body as List);

    final menuList = data.map((d) => MenuModel.fromMap(d)).toList();

    log('REPOSITORIO MENU: $menuList');

    return menuList;
  }
}
