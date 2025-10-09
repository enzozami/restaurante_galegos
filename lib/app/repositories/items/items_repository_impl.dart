import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';

import './items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final RestClient _restClient;

  ItemsRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<List<ItemModel>> getItems() async {
    final result = await _restClient.get('/products');

    if (result.hasError) {
      log('Erro ao carregar items');
      throw Exception('Erro ao carregar items');
    }

    final data = List<Map<String, dynamic>>.from(result.body);

    final items = data.map((i) => ItemModel.fromMap(i)).toList();

    // final items = result.body['products']
    //     .map<List<ItemModel>>(
    //       (produto) => produto['items'],
    //     )
    //     .toList();

    log('$items');

    return items;
  }
}
