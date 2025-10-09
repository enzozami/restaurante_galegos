import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/items/items_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';

class ProductsController extends GetxController with LoaderMixin, MessagesMixin {
  final ProductsServices _productsServices;
  final ItemsServices _itemsServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final product = <ProductModel>[].obs;
  final items = <ItemModel>[].obs;

  ProductsController({
    required ProductsServices productsServices,
    required ItemsServices itemsServices,
  })  : _productsServices = productsServices,
        _itemsServices = itemsServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      log('ASDJAHDWKJAHKSJDHWJAKJSDHWASD GETPRODUCTS');
      _loading.toggle();
      final products = await _productsServices.getProducts();
      final itemData = await _itemsServices.getItems();
      product.assignAll(products);
      items.assignAll(itemData);
      _loading.toggle();
    } catch (e) {
      _loading.toggle();
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
}
