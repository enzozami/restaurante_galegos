import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/products_service.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class ProductsController extends GetxController with LoaderMixin, MessagesMixin {
  // --- 2. SERVIÇOS (Dependências Injetadas) ---
  final AuthService _authService;
  final CarrinhoServices _carrinhoServices;
  final ProductsService _productsService;

  ScrollController scrollController = ScrollController();

  // --- ESTADO REATIVO PRIVADO   ---
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  // --- DADOS/ESTADO PÚBLICO REATIVO ---
  final Rx<String?> categoryId = Rx(null);
  final RxList itemsFiltrados = <ProductModel>[].obs;
  final isProcessing = RxBool(false);

  // Estado de Seleção
  final categorySelected = Rxn<CategoryModel>();
  final itemSelect = Rxn<ProductModel>();

  // Estado da Compra (para o modal)
  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;

  // --- GETTERS ---
  ProductModel? get selectedItem => itemSelect.value;
  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;

  RxList<ProductModel> get items => _productsService.items;
  RxList<CategoryModel> get category => _productsService.categories;

  // --- Construtor ---
  ProductsController({
    required AuthService authService,
    required CarrinhoServices carrinhoServices,
    required ProductsService productsService,
  })  : _carrinhoServices = carrinhoServices,
        _authService = authService,
        _productsService = productsService;

  bool get admin => _authService.isAdmin();
  void updateListItems(int id, ProductModel item) => _productsService.updateTemHoje(id, item);

  void cadastrar(
    String name,
    double price,
    String? description,
  ) {
    if (categoryId.value != null) {
      final category = categoryId.value!;

      _productsService.cadastrarProduto(
        category,
        name,
        price,
        description,
      );
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

    if (!admin) {
      ever<List<ProductModel>>(items, (_) {
        items.where((e) => e.temHoje).toList();
      });
    } else {
      ever<List<ProductModel>>(items, (_) {
        items.where((e) => e.temHoje).toList();
        itemsFiltrados.value = items;
      });
    }
  }

  // 9. Renomeado e tornado privado e mais robusto
  Future<void> _fetchProductsAndItems() async {
    try {
      // _loading(true);
      await _productsService.init();
      log('_fetchProductsAndItems');

      itemsFiltrados.assignAll(items);
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
    try {
      if (isProcessing.value == false) {
        isProcessing.value = true;
        if (categoryModel == null) return;

        final currentCategory = categorySelected.value;

        if (categoryModel.name == currentCategory?.name) {
          log('messageh');
          categorySelected.value = null;
          _fetchProductsAndItems();
          // itemsFiltrados.value = items;
          return;
        }
        categorySelected.value = categoryModel;

        final filtered = items
            .where(
              (e) => e.categoryId == (categorySelected.value!.name),
            )
            .toList();
        // itemsFiltrados.value = filtered;
        log('searchItemsByFilter $items');
        itemsFiltrados.assignAll(filtered);
        log('searchItemsByFilter itemsFiltrados $itemsFiltrados');
      }
    } catch (e, s) {
      log('Erro ao filtrar', error: e, stackTrace: s);
    } finally {
      _loading(false);
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

    _carrinhoServices.addOrUpdateProduct(
      selected,
      quantity: _quantity.value,
    );
    log('QUANTIDADE ENVIADA : $quantity');
    Get.close(0);
  }

  Future<void> refreshProducts() async {
    try {
      // itemsFiltrados.value = items;
      _fetchProductsAndItems();
      categorySelected.value = null;
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
