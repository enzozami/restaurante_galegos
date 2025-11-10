import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/products_service.dart';
import 'package:restaurante_galegos/app/models/item.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class ProductsController extends GetxController with LoaderMixin, MessagesMixin {
  // --- 2. SERVIÇOS (Dependências Injetadas) ---
  final AuthService _authService;
  final ProductsServices _productsServices;
  final CarrinhoServices _carrinhoServices;
  final ProductsService _productsService;

  ScrollController scrollController = ScrollController();

  // --- ESTADO REATIVO PRIVADO   ---
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  // Backups para filtragem
  final _productsOriginal = <ProductModel>[];
  final _itemsOriginal = <Item>[];

  // --- DADOS/ESTADO PÚBLICO REATIVO ---
  // final items = <Item>[].obs;
  RxList<Item> get items => _productsService.items;
  final itensFiltrados = <Item>[].obs;
  final products = <ProductModel>[].obs;

  // Estado de Seleção
  final categorySelected = Rxn<ProductModel>();
  final itemSelect = Rxn<Item>();

  // Estado da Compra (para o modal)
  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;

  // --- GETTERS ---
  Item? get selectedItem => itemSelect.value;
  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;

  // --- Construtor ---
  ProductsController({
    required AuthService authService,
    required ProductsServices productsServices,
    required CarrinhoServices carrinhoServices,
    required ProductsService productsService,
  })  : _productsServices = productsServices,
        _carrinhoServices = carrinhoServices,
        _authService = authService,
        _productsService = productsService;

  final isAdmin = false.obs;
  void updateListItems(int id, Item item) => _productsService.updateTemHoje(id, item);

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    final admin = _authService.isAdmin();

    if (admin) {
      isAdmin.value = true;
    }

    ever<int>(_quantity, (quantity) {
      _totalPrice(selectedItem?.price);
    });

    ever<List<Item>>(items, (_) {
      final filtered = _itemsOriginal.where((e) => e.temHoje).toList();
      itensFiltrados.assignAll(filtered);
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _fetchProductsAndItems();
  }

  // 9. Renomeado e tornado privado e mais robusto
  Future<void> _fetchProductsAndItems() async {
    _loading(true);
    try {
      final productsData = await _productsServices.getProducts();
      products.assignAll(productsData);
      _productsOriginal
        ..clear()
        ..addAll(productsData);

      _productsService.refreshItens();
      final filtered = _itemsOriginal.where((e) => e.temHoje).toList();
      itensFiltrados.assignAll(filtered);
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

  void searchItemsByFilter(ProductModel? productModel) {
    try {
      // _loading(true);
      if (productModel == null) return;

      final currentCategory = categorySelected.value;

      if (productModel.category == currentCategory?.category) {
        categorySelected.value = null;
        products.assignAll(_productsOriginal);
        items.assignAll(_itemsOriginal);
        return;
      }

      categorySelected.value = productModel;

      final newItems = _itemsOriginal
          .where(
            (e) => e.categoryId == (categorySelected.value?.category ?? ''),
          )
          .toList();

      items.assignAll(newItems);
    } catch (e, s) {
      log('Erro ao filtrar', error: e, stackTrace: s);
    } finally {
      _loading(false);
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

  void setSelectedItem(Item item) {
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

    _carrinhoServices.addOrUpdateProduct(
      selected,
      quantity: _quantity.value,
    );
    log('QUANTIDADE ENVIADA : $quantity');
    Get.close(0);
  }

  Future<void> refreshProducts() async {
    try {
      await _fetchProductsAndItems();
    } catch (e, s) {
      log('Erro ao atualizar produtos', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao atualizar produtos',
          type: MessageType.error,
        ),
      );
    }
  }
}
