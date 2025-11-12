import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final RestClient _restClient;

  ProductsRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<List<ProductModel>> getProducts() async {
    final result = await _restClient.get('/products');

    if (result.hasError) {
      log('Erro ao carregar items', error: result.statusText, stackTrace: StackTrace.current);
      RestClientException(message: 'Erro ao carregar itens');
    }

    return [];
  }

  @override
  Future<void> updateTemHoje(int id, ProductModel item, bool novoValor) async {
    final result = await _restClient.get('/products/$id');
    if (result.hasError) {}

    final products = Map<String, dynamic>.from(result.body);

    for (var items in products['items']) {
      if (items['id'] == item.id) {
        items['temHoje'] = novoValor;
      }
    }

    final put = await _restClient.put('/products/$id', products);

    if (put.hasError) {}
  }
}
