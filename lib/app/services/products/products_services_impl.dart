import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';

import 'products_services.dart';

class ProductsServicesImpl extends GetxService implements ProductsServices {
  final ProductsRepository _productsRepository;

  final _items = <ProductModel>[].obs;
  final _categories = <CategoryModel>[].obs;

  ProductsServicesImpl({required ProductsRepository productsRepository})
    : _productsRepository = productsRepository;

  @override
  Future<ProductsServices> init() async {
    await refreshCategories();
    await refreshItens();
    return this;
  }

  @override
  Future<List<ProductModel>> getProducts() => _productsRepository.getProducts();

  @override
  Future<List<CategoryModel>> getCategories() => _productsRepository.getCategories();

  @override
  Future<void> updateTemHoje(int id, ProductModel item) async {
    final novoValor = !item.temHoje;
    await _productsRepository.updateTemHoje(id, item, novoValor);

    final index = _items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _items.value[index] = items[index].copyWith(temHoje: novoValor);
    }
  }

  @override
  Future<ProductModel> cadastrarProdutos(
    String category,
    String name,
    double price,
    String? description,
  ) async {
    final produto = _criarProduto(category, name, price, description);
    return await _productsRepository.cadastrarProdutos(produto);
  }

  @override
  Future<void> deletarProdutos(ProductModel item) async {
    await _productsRepository.deletarProdutos(item);
    await refreshItens();
  }

  @override
  Future<void> atualizarDados(
    int id,
    String newCategoryId,
    String newDescription,
    String newName,
    double newPrice,
  ) async {
    await _productsRepository.atualizarDados(id, newCategoryId, newDescription, newName, newPrice);
    await refreshItens();
  }

  Future<void> refreshItens() async {
    _items.assignAll(await getProducts());
  }

  Future<void> refreshCategories() async {
    _categories.assignAll(await getCategories());
  }

  @override
  RxList<CategoryModel> get categories => _categories;

  @override
  RxList<ProductModel> get items => _items;

  ProductModel _criarProduto(String category, String name, double price, String? description) {
    return ProductModel(
      id: (items.isEmpty ? 1 : items.last.id + 1),
      categoryId: category,
      name: name,
      temHoje: true,
      price: price,
      description: description,
      image: '',
    );
  }
}
