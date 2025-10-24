import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/items/items_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/shopping/shopping_card_services.dart';

class ProductsController extends GetxController with LoaderMixin, MessagesMixin {
  // --- 2. SERVIÇOS (Dependências Injetadas) ---
  final ProductsServices _productsServices;
  final ItemsServices _itemsServices;
  final ShoppingCardServices _shoppingCardServices;

  final ScrollController scrollController = ScrollController();

  // --- ESTADO REATIVO PRIVADO   ---
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  // Backups para filtragem
  final _productsOriginal = <ProductModel>[];
  final _itemsOriginal = <ItemModel>[];

  // --- DADOS/ESTADO PÚBLICO REATIVO ---
  final items = <ItemModel>[].obs;
  final products = <ProductModel>[].obs;

  // Estado de Seleção
  final categorySelected = Rxn<ProductModel>();
  final itemSelect = Rxn<ItemModel>();

  // Estado da Compra (para o modal)
  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;

  // --- GETTERS ---
  ItemModel? get selectedItem => itemSelect.value;
  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;

  // --- Construtor ---
  ProductsController({
    required ProductsServices productsServices,
    required ItemsServices itemsServices,
    required ShoppingCardServices shoppingCardServices,
  })  : _productsServices = productsServices,
        _itemsServices = itemsServices,
        _shoppingCardServices = shoppingCardServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    ever<ItemModel?>(itemSelect, (item) {
      if (item != null) {
        // log('ITEM SELECIONADO: ${item.name}');
        final list = _shoppingCardServices.productsSelected
            .where((element) => element.product?.id == item.id);
        // log('VER SE TEM NA LISTA: $list');
        if (list.isNotEmpty) {
          final itemList = list.map((e) => e.product?.id).toList();

          if (itemList.isNotEmpty && itemList.contains(item.id)) {
            _quantity(list.first.quantity);
            _totalPrice(item.price * quantity);
          }
        } else {
          _alreadyAdded(false);
          _quantity(1);
        }
        update();
      }
    });

    ever<int>(_quantity, (quantity) {
      log('QUANTIDADE EVER: $quantity');
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

      final itemData = await _itemsServices.getItems();
      items.assignAll(itemData);
      _itemsOriginal
        ..clear()
        ..addAll(itemData);
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
    // Removi 'async' desnecessário
    _loading(true);
    try {
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
    if (_quantity.value > 1) {
      _quantity.value--;
    }
  }

  void addItemsToCart() {
    final selected = selectedItem;

    if (selected == null) {
      _alreadyAdded(false);
      return;
    }
    _shoppingCardServices.addOrUpdateProduct(
      selected,
      quantity: quantity,
    );
    log('QUANTIDADE ENVIADA : $quantity');
    Get.back();
  }
}
