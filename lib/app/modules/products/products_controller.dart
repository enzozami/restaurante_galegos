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
  final ProductsServices _productsServices;
  final ItemsServices _itemsServices;
  final ShoppingCardServices _shoppingCardServices;

  // --- 3. DADOS DE APRESENTAÇÃO/CONTROLE (Não reativos ou de terceiros) ---
  final ScrollController scrollController = ScrollController();

  // --- 4. ESTADO REATIVO PRIVADO (os "._") ---
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  // Backups para filtragem
  final _productsOriginal = <ProductModel>[];
  final _itemsOriginal = <ItemModel>[];

  // --- 5. DADOS/ESTADO PÚBLICO REATIVO (os ".obs" que a View acessa) ---
  final items = <ItemModel>[].obs;
  final products = <ProductModel>[].obs;

  // Estado de Seleção
  final categorySelected = Rxn<ProductModel>();
  final itemSelect = Rxn<ItemModel>();

  // Estado da Compra
  final _quantity = 1.obs;
  final _alreadyAdded = false.obs;
  final _totalPrice = 0.0.obs;

  // --- 6. GETTERS ---
  // Renomeado para 'selectedItem'
  ItemModel? get selectedItem => itemSelect.value;
  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;

  // --- Construtor ---
  ProductsController({
    required ProductsServices productsServices,
    required ItemsServices itemsServices,
    // Corrigido para ShoppingCartServices
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
        _quantity.value = 1;
        _totalPrice(item.price * _quantity.value);
      } else {
        _quantity.value = 1;
        _totalPrice.value = 0.0;
      }
      _alreadyAdded.value = false;
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    try {
      await getProdutos();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());

      _message(MessageModel(title: 'Erro', message: 'Erro ', type: MessageType.error));
    }
  }

  Future<void> getProdutos() async {
    try {
      _loading.toggle();
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

      _loading.toggle();
    } catch (e, s) {
      _loading.toggle();
      log('Erro ao carregar categorias', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao carregar categorias',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading(false);
    }
  }

  void searchItemsByFilter(ProductModel? productModel) async {
    try {
      _loading.toggle();
      if (productModel == null) return;

      final currentCategory = categorySelected.value;

      if (productModel.category == currentCategory?.category) {
        categorySelected.value = null;
        products.assignAll(_productsOriginal);
        items.assignAll(_itemsOriginal);
        return;
      }

      categorySelected.value = productModel;

      final newItem = _itemsOriginal
          .where(
            (e) => e.categoryId == categorySelected.value!.category,
          )
          .toList();

      items.assignAll(newItem);
      _loading.toggle();
    } catch (e, s) {
      _loading.toggle();
      log('Erro ao filtrar', error: e, stackTrace: s);
    } finally {
      _loading(false);
    }
  }

  void addProductUnit() {
    _quantity.value++;
  }

  void removeProductUnit() {
    if (_quantity.value > 0) _quantity.value--;
  }

  void addItemsToCart() {
    final selected = selectedItem;

    if (selected == null) {
      _alreadyAdded.value = false;
      return;
    }

    _shoppingCardServices.addOrUpdateProduct(
      selected,
      quantity: quantity,
    );
    _alreadyAdded.value = true;
    _quantity.value = 1;
    itemSelect.value = null;
    Get.back();
  }
}
