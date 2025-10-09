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

  final items = <ItemModel>[].obs;
  final product = <ProductModel>[].obs;

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
    try {
      final itemData = await _itemsServices.getItems();
      log('itemData runtimeType: ${itemData.runtimeType}');
      log('itemData content: $itemData');
      items.assignAll(itemData);

      getProducts();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());

      _message(MessageModel(title: 'Erro', message: 'Erro ', type: MessageType.error));
    }
  }

  Future<void> getProducts() async {
    try {
      log('ASDJAHDWKJAHKSJDHWJAKJSDHWASD GETPRODUCTS');
      _loading.toggle();
      final products = await _productsServices.getProducts();
      product.assignAll(products);

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
