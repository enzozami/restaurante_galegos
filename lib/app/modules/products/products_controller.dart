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
  final AuthServices _authService;
  final CarrinhoServices _carrinhoServices;
  final ProductsServices _productsServices;

  ScrollController scrollController = ScrollController();

  final isProcessing = RxBool(false);
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final Rx<String?> categoryId = Rx(null);

  final categorySelected = Rxn<CategoryModel>();
  final itemSelect = Rxn<ProductModel>();

  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;
  final _isEditing = false.obs;

  RxBool get loading => _loading; // carregamento
  RxList<ProductModel> get items => _productsServices.items; // itens da api
  RxList<CategoryModel> get category => _productsServices.categories; // categorias da api
  ProductModel? get selectedItem => itemSelect.value; // item que é selecionado
  int get quantity => _quantity.value; // quantidade de itens
  bool get alreadyAdded => _alreadyAdded.value; // se está no carrinho ou nao
  double get totalPrice => _totalPrice.value; // valor total do carrinho
  CarrinhoServices get carrinhoServices => _carrinhoServices; // carrinho
  bool get isEditing => _isEditing.value; // se está editando ou nao
  bool get admin => _authService.isAdmin(); // se é admin ou nao
  RxBool temHoje(ProductModel p) => RxBool(p.temHoje); // se tem no dia ou nao

  ProductsController({
    required AuthServices authService,
    required CarrinhoServices carrinhoServices,
    required ProductsServices productsServices,
  }) : _carrinhoServices = carrinhoServices,
       _authService = authService,
       _productsServices = productsServices;

  @override
  void onInit() async {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    ever<int>(_quantity, (quantity) {
      _totalPrice(selectedItem?.price);
    });

    ever<List<ProductModel>>(items, (_) {
      items.where((e) => e.temHoje).toList();
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _fetchAllProducts();
  }

  Future<void> _fetchAllProducts() async {
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

  Future<void> atualizarItensDoDia(int id, ProductModel item) async {
    await _productsServices.updateTemHoje(id, item);
  }

  void cadastrarNovosProdutos(String name, double price, String? description) {
    if (categoryId.value != null) {
      final category = categoryId.value!;

      _productsServices.cadastrarProdutos(category, name, price, description);
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
  }

  Future<void> refreshProducts() async {
    try {
      if (categorySelected.value != null) {
        categorySelected.value = null;
      }
      _fetchAllProducts();
    } catch (e, s) {
      log('Erro ao atualizar produtos', error: e, stackTrace: s);
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao atualizar produtos', type: MessageType.error),
      );
    }
  }

  Future<void> apagarProduto(ProductModel item) => _productsServices.deletarProdutos(item);

  Future<void> atualizarDadosDoProduto(
    int id,
    String newCategoryId,
    String newDescription,
    String newName,
    double newPrice,
  ) => _productsServices.atualizarDados(id, newCategoryId, newDescription, newName, newPrice);
}
