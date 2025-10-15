import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/items/items_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/shopping/shopping_services.dart';

class ProductsController extends GetxController with LoaderMixin, MessagesMixin {
  final ProductsServices _productsServices;
  final ScrollController scrollController = ScrollController();
  final ItemsServices _itemsServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final ShoppingServices _shoppingServices;
  final _itemModel = Rxn<ItemModel>();
  ItemModel? get item => _itemModel.value;
  void selectItem(ItemModel newItem) {
    _itemModel.value = newItem;
  }

  final _quantity = 0.obs;
  final _alreadyAdded = false.obs;
  bool get alreadyAdded => _alreadyAdded.value;

  final items = <ItemModel>[].obs;
  final product = <ProductModel>[].obs;

  var _productOriginal = <ProductModel>[];
  final _itemsOriginal = <ItemModel>[];

  final categorySelected = Rxn<ProductModel>();

  ProductsController({
    required ProductsServices productsServices,
    required ItemsServices itemsServices,
    required ShoppingServices shoppingServices,
  })  : _productsServices = productsServices,
        _itemsServices = itemsServices,
        _shoppingServices = shoppingServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    if (item != null) {
      final shoppingItem = _shoppingServices.getById(item!.id);
      if (shoppingItem != null) {
        _quantity(shoppingItem.quantity);
        _alreadyAdded(true);
      }
    }
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
      product.assignAll(productsData);
      _productOriginal = productsData;

      final itemData = await _itemsServices.getItems();
      items.assignAll(itemData);
      _itemsOriginal
        ..clear()
        ..addAll(itemData);

      _loading.toggle();
    } catch (e, s) {
      _loading.toggle();
      log('ERROOOOOOOOOOOOOOOOOO', error: e, stackTrace: s);
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
    if (productModel?.category == categorySelected.value?.category) {
      categorySelected.value = null;
    } else {
      categorySelected.value = productModel;
    }

    if (categorySelected.value == null) {
      product.assignAll(_productOriginal);
      return;
    }

    var newProducts =
        _productOriginal.where((p) => p.category == categorySelected.value!.category).toList();

    var newItems =
        _itemsOriginal.where((e) => e.categoryId == categorySelected.value!.category).toList();

    product.assignAll(newProducts);
    items.assignAll(newItems);
  }

  void addProduct() {
    _quantity.value++;
  }

  void addProductInShoppingCard() {
    _shoppingServices.addAndRemoveItemInShoppingCard(
      item,
      quantity: _quantity.value,
    );
  }
}
