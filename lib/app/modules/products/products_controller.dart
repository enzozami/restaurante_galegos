import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class ProductsController extends GetxController with LoaderMixin, MessagesMixin {
  // --- 2. SERVIÇOS (Dependências Injetadas) ---
  final AuthServices _authService;
  final CarrinhoServices _carrinhoServices;
  final ProductsServices _productsServices;

  ScrollController scrollController = ScrollController();

  // --- ESTADO REATIVO PRIVADO   ---
  final _loading = false.obs;

  RxBool get loading => _loading;
  final _message = Rxn<MessageModel>();

  // --- DADOS/ESTADO PÚBLICO REATIVO ---
  final Rx<String?> categoryId = Rx(null);

  // final RxList<ProductModel> itemsFiltrados = <ProductModel>[].obs;
  final isProcessing = RxBool(false);

  // Estado de Seleção
  final categorySelected = Rxn<CategoryModel>();
  final itemSelect = Rxn<ProductModel>();

  // Estado da Compra (para o modal)
  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;
  final _isEditing = false.obs;

  // --- GETTERS ---
  ProductModel? get selectedItem => itemSelect.value;

  int get quantity => _quantity.value;

  bool get alreadyAdded => _alreadyAdded.value;

  double get totalPrice => _totalPrice.value;

  CarrinhoServices get carrinhoServices => _carrinhoServices;

  bool get isEditing => _isEditing.value;

  RxList<ProductModel> get items => _productsServices.items;

  RxList<CategoryModel> get category => _productsServices.categories;

  // --- Construtor ---
  ProductsController({
    required AuthServices authService,
    required CarrinhoServices carrinhoServices,
    required ProductsServices productsServices,
  }) : _carrinhoServices = carrinhoServices,
       _authService = authService,
       _productsServices = productsServices;

  bool get admin => _authService.isAdmin();

  Future<void> updateListItems(int id, ProductModel item) async {
    await _productsServices.updateTemHoje(id, item);
  }

  void addProduct(String name, double price, String? description) {
    if (categoryId.value != null) {
      final category = categoryId.value!;

      _productsServices.cadastrarProdutos(category, name, price, description);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    await _fetchProductsAndItems();

    ever<int>(_quantity, (quantity) {
      _totalPrice(selectedItem?.price);
    });

    ever<List<ProductModel>>(items, (_) {
      items.where((e) => e.temHoje).toList();
      // itemsFiltrados.refresh();
    });
  }

  // 9. Renomeado e tornado privado e mais robusto
  Future<void> _fetchProductsAndItems() async {
    try {
      _loading(true);
      await _productsServices.init();
    } catch (e, s) {
      log('Erro ao carregar dados', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Não foi possível carregar os produtos e categorias.',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading(false);
    }
  }

  void searchItemsByFilter(CategoryModel? categoryModel) {
    if (isProcessing.value) return;

    try {
      isProcessing.value = true;
      _loading.value = true;

      if (categoryModel == null) {
        categorySelected.value = null;
        return;
      }

      // Toggle da categoria
      final selected = categorySelected.value;
      if (selected?.name == categoryModel.name) {
        categorySelected.value = null;
        return;
      }

      categorySelected.value = categoryModel;
    } catch (e, s) {
      log('Erro ao filtrar', error: e, stackTrace: s);
    } finally {
      _loading.value = false;
      isProcessing.value = false;
    }
  }

  void addProductUnit() {
    _quantity.value++;
  }

  void removeProductUnit() {
    if (_quantity.value > 0) {
      _quantity.value--;
    }
  }

  void removeAllProductsUnit() {
    _quantity.value = 0;
  }

  void setSelectedItem(ProductModel item) {
    itemSelect.value = item;

    final carrinhoItem = _carrinhoServices.getById(item.id);
    if (carrinhoItem != null) {
      _quantity(carrinhoItem.item.quantidade);
      _alreadyAdded(true);
    } else {
      _quantity(1);
      _alreadyAdded(false);
    }
  }

  void addItemsToCart() {
    final selected = selectedItem;

    if (selected == null) {
      _alreadyAdded(false);
      return;
    }

    _carrinhoServices.addOrUpdateProduct(selected, quantity: _quantity.value);
    log('QUANTIDADE ENVIADA : $quantity');
  }

  Future<void> refreshProducts() async {
    try {
      // itemsFiltrados.value = items;
      if (categorySelected.value != null) {
        categorySelected.value = null;
      }
      _fetchProductsAndItems();
    } catch (e, s) {
      log('Erro ao atualizar produtos', error: e, stackTrace: s);
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao atualizar produtos', type: MessageType.error),
      );
    }
  }

  Future<void> deletarProd(ProductModel item) => _productsServices.deletarProdutos(item);

  Future<void> updateData(
    int id,
    String newCategoryId,
    String newDescription,
    String newName,
    double newPrice,
  ) => _productsServices.atualizarDados(id, newCategoryId, newDescription, newName, newPrice);

  RxBool temHoje(ProductModel p) => RxBool(p.temHoje);
}
