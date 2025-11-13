import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';

import 'products_services.dart';

class ProductsServicesImpl implements ProductsServices {
  final ProductsRepository _productsRepository;

  ProductsServicesImpl({required ProductsRepository productsRepository})
      : _productsRepository = productsRepository;

  @override
  Future<List<ProductModel>> getProducts() => _productsRepository.getProducts();

  @override
  Future<void> updateTemHoje(int id, ProductModel item, bool novoValor) =>
      _productsRepository.updateTemHoje(id, item, novoValor);

  @override
  Future<List<CategoryModel>> getCategories() => _productsRepository.getCategories();

  @override
  Future<ProductModel> cadastrarProdutos(ProductModel item) =>
      _productsRepository.cadastrarProdutos(item);
}
