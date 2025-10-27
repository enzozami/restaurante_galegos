import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/item.dart';

import './items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final RestClient _restClient;

  ItemsRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<List<Item>> getItems() async {
    final result = await _restClient.get('/products');

    if (result.hasError) {
      log('Erro ao carregar items', error: result.statusText, stackTrace: StackTrace.current);
      RestClientException(message: 'Erro ao carregar itens');
    }

    final data = (result.body as List);

    var list = [];
    // log('DATA: $data');

// feito pela julie
    for (var item in data) {
      final listData = [...(item['items'] as List).map((e) => e)];
      list.add(listData);
      // log('ITEMS: $list');
    }
    // log('Lista de ITEMS: $list');

    return list.expand((e) => e).map((e) => Item.fromMap(e)).toList();
  }
}
