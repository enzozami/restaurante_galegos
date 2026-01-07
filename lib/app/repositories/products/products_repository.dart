import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';

abstract interface class ProductsRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> cadastrarProdutos(ProductModel item);
  Future<void> deletarProdutos(ProductModel item);
  Future<void> atualizarDados(
    ProductModel product,
    String? newDescription,
    String? newName,
    double? newPrice,
    bool? newTemHoje,
  );
}
