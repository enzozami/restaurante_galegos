import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';

abstract interface class ProductsServices {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<void> updateTemHoje(int id, ProductModel item, bool novoValor);
  Future<ProductModel> cadastrarProdutos(ProductModel item);
  Future<void> deletarProdutos(ProductModel item);
}
