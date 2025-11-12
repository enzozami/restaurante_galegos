import 'package:restaurante_galegos/app/models/product_model.dart';

abstract interface class ProductsRepository {
  Future<List<ProductModel>> getProducts();
  Future<void> updateTemHoje(int id, ProductModel item, bool novoValor);
}
