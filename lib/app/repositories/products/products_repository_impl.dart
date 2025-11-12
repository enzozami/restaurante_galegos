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
      log(
        'Erro ao carregar items',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      RestClientException(message: 'Erro ao carregar itens');
    }
    final data = (result.body as List);

    return data.map((e) => ProductModel.fromMap(e)).toList();
  }

  @override
  Future<void> updateTemHoje(int id, ProductModel item, bool novoValor) async {
    final result = await _restClient.put('/products/$id', {
      'temHoje': novoValor,
    });
    if (result.hasError) {
      log(
        'Erro ao atualizar (temHoje)',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      RestClientException(message: 'Erro ao atualizar (temHoje)');
    }
  }
}
