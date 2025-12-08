import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_dialog_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/alert_products_lunchboxes_adm.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_plus_minus.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class ProductsController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authService;
  final CarrinhoServices _carrinhoServices;
  final ProductsServices _productsServices;

  ProductsController({
    required AuthServices authService,
    required CarrinhoServices carrinhoServices,
    required ProductsServices productsServices,
  }) : _carrinhoServices = carrinhoServices,
       _authService = authService,
       _productsServices = productsServices;

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

  ScrollController scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameProductEC = TextEditingController();
  final TextEditingController descriptionEC = TextEditingController();
  final TextEditingController priceEC = TextEditingController();

  RxBool get loading => _loading;
  RxList<ProductModel> get items => _productsServices.items;
  RxList<CategoryModel> get category => _productsServices.categories;
  ProductModel? get selectedItem => itemSelect.value;
  int get quantity => _quantity.value;
  bool get alreadyAdded => _alreadyAdded.value;
  double get totalPrice => _totalPrice.value;
  CarrinhoServices get carrinhoServices => _carrinhoServices;
  bool get isEditing => _isEditing.value;
  bool get admin => _authService.isAdmin();
  RxBool temHoje(ProductModel p) => RxBool(p.temHoje);

  List<ProductModel> getFilteredProducts(CategoryModel c) {
    return admin
        ? items.where((p) {
            final matchesCategory = categorySelected.value?.name == null
                ? p.categoryId == c.name
                : p.categoryId == categorySelected.value?.name && p.categoryId == c.name;
            return matchesCategory;
          }).toList()
        : items.where((p) {
            final matchsCategory = categorySelected.value?.name == null
                ? p.categoryId == c.name
                : p.categoryId == categorySelected.value?.name && p.categoryId == c.name;
            return matchsCategory && p.temHoje;
          }).toList();
  }

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

  @override
  void onClose() {
    scrollController.dispose();
    nameProductEC.dispose();
    descriptionEC.dispose();
    priceEC.dispose();
    super.onClose();
  }

  Future<void> _fetchAllProducts() async {
    try {
      _loading.value = true;
      await _productsServices.init();
    } catch (e, s) {
      log('Erro ao carregar dados', error: e, stackTrace: s);
      _loading.value = false;
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Não foi possível carregar os produtos e categorias.',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    try {
      if (categorySelected.value != null) {
        categorySelected.value = null;
      }
      await _fetchAllProducts();
    } catch (e, s) {
      log('Erro ao atualizar produtos', error: e, stackTrace: s);
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao atualizar produtos', type: MessageType.error),
      );
    }
  }

  Future<void> cadastrarNovosProdutos() async {
    if (!_validateForm()) return;

    if (categoryId.value != null) {
      final category = categoryId.value!;

      await _productsServices.cadastrarProdutos(
        category,
        nameProductEC.text,
        double.parse(priceEC.text),
        descriptionEC.text,
      );
    }
    await refreshProducts();
  }

  Future<void> apagarProduto(ProductModel item) async =>
      await _productsServices.deletarProdutos(item);

  Future<void> atualizarDadosDoProduto(
    int id,
    String newCategoryId,
    String newDescription,
    String newName,
    double newPrice,
  ) async =>
      await _productsServices.atualizarDados(id, newCategoryId, newDescription, newName, newPrice);

  Future<void> atualizarItensDoDia(int id, ProductModel item) async {
    await _productsServices.updateTemHoje(id, item);
    await refreshProducts();
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

  void addProductUnit() {
    _quantity.value++;
  }

  void removeProductUnit() {
    if (_quantity.value > 0) {
      _quantity.value--;
    }
  }

  void onClientProductQuickAddPressed(ProductModel product) {
    setSelectedItem(product);
    final idItem = carrinhoServices.getById(product.id);
    if (idItem == null) {
      addItemsToCart();
      Get.snackbar(
        'Item: ${product.name}',
        'Item adicionado ao carrinho',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFFE2933C),
        colorText: Colors.black,
        isDismissible: true,
        overlayBlur: 0,
        overlayColor: Colors.transparent,
        barBlur: 0,
      );
    } else {
      addProductUnit();
      addItemsToCart();
    }
  }

  void onClientProductDetailsTapped(BuildContext context, ProductModel product) {
    setSelectedItem(product);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogDefault(
          visible: quantity > 0 && alreadyAdded == true,
          plusMinus: Obx(() {
            return GalegosPlusMinus(
              addCallback: addProductUnit,
              removeCallback: removeProductUnit,
              quantityUnit: quantity,
            );
          }),
          item: product,
          onPressed: () {
            final idItem = carrinhoServices.getById(product.id);

            if (idItem == null) {
              addItemsToCart();
              Get.snackbar(
                'Item: ${product.name}',
                'Item adicionado ao carrinho',
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFFE2933C),
                colorText: Colors.black,
                isDismissible: true,
                overlayBlur: 0,
                overlayColor: Colors.transparent,
                barBlur: 0,
              );
              Get.close(0);
              log('Item clicado: ${product.name} - ${product.price}');
            } else {
              addItemsToCart();
              Get.close(0);
              log('Item clicado: ${product.name} - ${product.price}');
            }
          },
        );
      },
    );
  }

  void onAdminProductUpdateDetailsTapped(BuildContext context, ProductModel product) {
    setSelectedItem(product);
    final number = NumberFormat('#,##0.00', 'pt_BR');
    final temHoje = RxBool(product.temHoje);

    showDialog(
      context: context,
      builder: (context) {
        final nameEC = TextEditingController(text: product.name);
        final descriptionEC = TextEditingController(
          text: product.description,
        );
        final categoryEC = TextEditingController(text: product.categoryId);
        final priceEC = TextEditingController(
          text: number.format(product.price),
        );
        return Form(
          key: formKey,
          child: AlertProductsLunchboxesAdm(
            isProduct: true,
            category: categoryEC,
            nameProduct: nameEC,
            description: descriptionEC,
            price: priceEC,
            onPressed: () async {
              if (_validateForm()) {
                final cleaned = priceEC.text.replaceAll('.', '').replaceAll(',', '.');
                atualizarDadosDoProduto(
                  product.id,
                  product.categoryId,
                  descriptionEC.text,
                  nameEC.text,
                  double.parse(cleaned),
                );
                Get.close(0);
              }
            },
            value: temHoje,
            onChanged: (value) async {
              temHoje.value = value;
              await atualizarItensDoDia(product.id, product);
            },
          ),
        );
      },
    );
  }

  Future<bool> exibirConfirmacaoDescarte(BuildContext context, ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: GalegosUiDefaut.colors['fundo'],
          titlePadding: EdgeInsets.only(top: 25, bottom: 0),
          contentPadding: EdgeInsets.only(top: 15, bottom: 0),
          actionsPadding: EdgeInsets.symmetric(vertical: 15),
          title: Text(
            'ATENÇÃO',
            textAlign: .center,
            style: GalegosUiDefaut.theme.textTheme.titleMedium,
          ),
          content: Text(
            'Deseja excluir esse produto?',
            textAlign: .center,
            style: GalegosUiDefaut.theme.textTheme.bodySmall,
          ),
          actionsAlignment: .center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
    return confirm == true;
  }

  bool _validateForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
