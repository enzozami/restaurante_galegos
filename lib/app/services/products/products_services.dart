import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';

abstract interface class ProductsServices {
  RxList<ProductModel> get items;
  RxList<CategoryModel> get categories;

  Future<ProductsServices> init();
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<void> updateTemHoje(int id, ProductModel item);
  Future<ProductModel> cadastrarProdutos(
    String category,
    String name,
    double price,
    String? description,
  );
  Future<void> deletarProdutos(ProductModel item);
  Future<void> atualizarDados(
    int id,
    String newCategoryId,
    String newDescription,
    String newName,
    double newPrice,
  );
}
