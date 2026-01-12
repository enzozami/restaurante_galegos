import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';

abstract interface class ProductsServices {
  RxList<ProductModel> get items;
  RxList<CategoryModel> get categories;

  Future<ProductsServices> init();
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> cadastrarProdutos(
    String category,
    String name,
    double price,
    String? description,
  );
  Future<void> deletarProdutos(ProductModel item);
  Future<void> atualizarDados({
    required ProductModel product,
    required String? newDescription,
    required String? newName,
    required double? newPrice,
    required bool? newTemHoje,
  });
  void refreshItens();
}
