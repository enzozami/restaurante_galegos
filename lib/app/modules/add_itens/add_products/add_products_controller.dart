import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';

class AddProductsController extends GetxController with LoaderMixin, MessagesMixin {
  final ProductsServices _productsServices;

  final RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  final RxString category = ''.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameEC = TextEditingController();
  final TextEditingController descriptionEC = TextEditingController();
  final TextEditingController priceEC = TextEditingController();

  AddProductsController({required ProductsServices productsServices})
    : _productsServices = productsServices;

  @override
  void onInit() {
    super.onInit();

    categoryList.value = _productsServices.categories;
  }

  void changeDropdown(String value) {
    category.value = value;
  }

  Future<void> cadastrarNovosProdutos() async {
    if (!_validateForm()) return;

    await _productsServices.cadastrarProdutos(
      category.value,
      nameEC.text,
      _formatValue(),
      descriptionEC.text,
    );
    _clear();
    _productsServices.refreshItens();
    Get.back();
  }

  void _clear() {
    category.close();
    nameEC.clear();
    descriptionEC.clear();
    priceEC.clear();
  }

  double _formatValue() {
    return double.parse(priceEC.text.replaceAll(r'R$ ', ''));
  }

  bool _validateForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
