import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';

import './products_services.dart';

class ProductsServicesImpl implements ProductsServices {
  final ProductsRepository _productsRepository;

  ProductsServicesImpl({required ProductsRepository productsRepository})
      : _productsRepository = productsRepository;

  @override
  Future<List<ProductModel>> getProducts() => _productsRepository.getProducts();
}
