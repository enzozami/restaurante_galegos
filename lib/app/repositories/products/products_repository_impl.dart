import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';

import './products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final RestClient _restClient;

  ProductsRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<List<ProductModel>> getProducts() async {
    final result = await _restClient.get<List<ProductModel>>(
      '/products',
      decoder: (data) {
        final resultData = data['products'];
        if (resultData != null) {
          return resultData.map((p) => ProductModel.fromMap(p)).toList();
        }
        return <ProductModel>[];
      },
    );

    if (result.hasError) {
      log('Erro ao buscar produtos');
      throw Exception('Erro ao buscar produtos');
    }

    return result.body ?? <ProductModel>[];
  }
}
