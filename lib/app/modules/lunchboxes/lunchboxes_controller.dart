import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/shopping/shopping_services.dart';

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final LunchboxesServices _lunchboxesServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final ShoppingServices _shoppingServices;
  final _quantity = 0.obs;
  int get quantity => _quantity.value;
  final _food = Rxn<AlimentoModel>();

  AlimentoModel? get food => _food.value;
  void selectFood(AlimentoModel newFood) {
    _food.value = newFood;
  }

  final _alreadyAdded = false.obs;
  bool get alreadyAdded => _alreadyAdded.value;

  final sizes = <String>[].obs;
  final _sizesOriginal = <String>[];

  final alimentos = <AlimentoModel>[].obs;
  final _alimentosOriginal = <AlimentoModel>[];

  final dayNow = FormatterHelper.formatDate();

  final sizeSelected = Rxn<String>();

  LunchboxesController({
    required LunchboxesServices lunchboxesServices,
    required ShoppingServices shoppingServices,
  })  : _lunchboxesServices = lunchboxesServices,
        _shoppingServices = shoppingServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
    if (food != null) {
      final foodShopping = _shoppingServices.getById(food!.id);
      if (foodShopping != null) {
        _quantity(foodShopping.quantity);
        _alreadyAdded(true);
      }
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await getLunchboxes();
  }

  Future<void> getLunchboxes() async {
    _loading.toggle();
    final menuData = await _lunchboxesServices.getMenu();
    final alimentosData = await _lunchboxesServices.getFood();

    final List<String> sizesList = List<String>.from(menuData.first.pricePerSize);

    sizes.assignAll(sizesList);
    _sizesOriginal
      ..clear()
      ..addAll(sizesList);

    final filtered = alimentosData.where((e) => e.dayName == dayNow);

    alimentos.assignAll(filtered);
    _alimentosOriginal
      ..clear()
      ..addAll(filtered);
    _loading.toggle();
  }

  void filterPrice(String selectedSize) {
    if (sizeSelected.value == selectedSize) {
      sizeSelected.value = '';
      sizes.assignAll(_sizesOriginal);
      return;
    }

    sizeSelected.value = selectedSize;

    final filtered = _alimentosOriginal.where((alimento) {
      return alimento.pricePerSize.containsKey((selectedSize));
    }).toList();

    sizes.assignAll(
        filtered.map((e) => e.pricePerSize.keys.toList()).expand((e) => e).toSet().toList());
  }

  void addFood() {
    _quantity.value++;
  }

  void addFoodInShoppingCard() {
    _shoppingServices.addAndRemoveFoodInShoppingCard(food, quantity: quantity);
  }
}
