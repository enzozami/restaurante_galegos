import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
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

    final List data = result.body;

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

  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await _restClient.get('/categories');

    if (result.hasError) {}

    final List data = (result.body);

    return data.map((e) => CategoryModel.fromMap(e)).toList();
  }

  @override
  Future<ProductModel> cadastrarProdutos(ProductModel item) async {
    final result = await _restClient.post('/products', {
      'id': item.id,
      'categoryId': item.categoryId,
      'name': item.name,
      'description': item.description ?? '',
      'temHoje': item.temHoje,
      'price': item.price
    });

    if (result.hasError) {
      log(
        'Erro ao cadastrar novo produto',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      RestClientException(message: 'Erro ao enviar novo pedido');
    }

    return ProductModel.fromMap(result.body);
  }
}
