import 'package:restaurante_galegos/app/models/product_model.dart';

abstract interface class ProductsRepository {
  Future<List<ProductModel>> getProducts();
}
