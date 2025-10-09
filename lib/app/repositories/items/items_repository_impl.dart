import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';

import './items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final RestClient _restClient;

  ItemsRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<List<ItemModel>> getItems() async {
    final result = await _restClient.get(
      '/products',
    );

    if (result.hasError) {
      log('Erro ao carregar items');
    }

    final data = (result.body as List);


    var list = [];


    
    for (var item in data) {
      list = [...(item['items'] as List).map((e) => e)];
    }

    // final itemData = data;
    // var lists = itemData.map((i) => i['items']).toList();

    return list.map((e) => ItemModel.fromMap(e)).toList();

    // return result.body ?? <ItemModel>[];
  }
}
