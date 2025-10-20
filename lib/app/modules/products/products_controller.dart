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
  final ScrollController scrollController = ScrollController();
  final ItemsServices _itemsServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final items = <ItemModel>[].obs;
  final product = <ProductModel>[].obs;

  var _productOriginal = <ProductModel>[];
  final _itemsOriginal = <ItemModel>[];

  final categorySelected = Rxn<ProductModel>();

  // SHOPPING CARD
  final ShoppingCardServices _shoppingCardServices;
  final itemSelect = Rxn<ItemModel>();
  ItemModel? get productsSelected => itemSelect.value;

  final _quantity = 1.obs;
  int get quantity => _quantity.value;
  final _alreadyAdded = false.obs;
  bool get alreadyAdded => _alreadyAdded.value;

  final _totalPrice = 0.0.obs;
  double get totalPrice => _totalPrice.value;

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

    // Usa 'productsSelected' que é um getter para 'itemSelect.value'
    // if (productsSelected != null) {
    //   _totalPrice(productsSelected!.price);

    //   // Apenas tenta buscar no carrinho se houver um item selecionado.
    //   final productShoppingCard = _shoppingCardServices.getById(productsSelected?.key);
    //   if (productShoppingCard != null) {
    //     _quantity(productShoppingCard.quantity);
    //     _alreadyAdded(true);
    //   }
    // }

    // O 'ever' deve ser seguro, pois ele só usará productsSelected se não for nulo.
    ever<int>(_quantity, (quantity) {
      if (productsSelected != null) {
        _totalPrice(productsSelected!.price * quantity);
      }
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

  void addItemsShoppingCard() {
    _shoppingCardServices.addOrUpdateProduct(
      productsSelected,
      quantity: quantity,
    );
    _quantity.value = 1;
    Get.back();
  }
}
