import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/cep_model.dart';
import 'package:restaurante_galegos/app/modules/home/home_controller.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class ShoppingCardController extends GetxController with LoaderMixin, MessagesMixin {
  final homeController = Get.find<HomeController>();

  final CarrinhoServices _carrinhoServices;

  final date = FormatterHelper.formatDateNumber();
  final time = FormatterHelper.formatDateAndTime();
  var id = 0;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final cepInput = ''.obs;
  final cep = ''.obs;
  final isProcessing = false.obs;
  final isOpen = true.obs;
  final quantityRx = Rxn<int>();
  final taxa = 0.0.obs;
  final rua = ''.obs;
  final bairro = ''.obs;
  final cidade = ''.obs;
  final estado = ''.obs;
  final numero = ''.obs;
  final cepMok = <CepModel>[].obs;

  RxBool get loading => _loading;
  int get quantity => quantityRx.value ?? 0;
  List<CarrinhoModel> get products => _carrinhoServices.itensCarrinho;

  ShoppingCardController({
    required CarrinhoServices carrinhoServices,
  }) : _carrinhoServices = carrinhoServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void addQuantityProduct(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateProduct(
      shoppingCardModel.item.produto!,
      quantity: shoppingCardModel.item.quantidade + 1,
    );
  }

  void removeQuantityProduct(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateProduct(
      shoppingCardModel.item.produto!,
      quantity: shoppingCardModel.item.quantidade - 1,
    );
  }

  void addQuantityFood(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateFood(
      shoppingCardModel.item.alimento!,
      quantity: shoppingCardModel.item.quantidade + 1,
      selectedSize: shoppingCardModel.item.tamanho ?? '',
    );
  }

  void removeQuantityFood(CarrinhoModel shoppingCardModel) {
    _carrinhoServices.addOrUpdateFood(
      shoppingCardModel.item.alimento!,
      quantity: shoppingCardModel.item.quantidade - 1,
      selectedSize: shoppingCardModel.item.tamanho ?? '',
    );
  }

  double? totalPay() {
    return _carrinhoServices.amountToPay ?? 0;
  }

  void clear() => _carrinhoServices.clear();

  void adicionarQuantidadeCarrinho(CarrinhoModel p) {
    if (p.item.alimento != null) {
      addQuantityFood(p);
    } else if (p.item.produto != null) {
      addQuantityProduct(p);
    }
  }

  void removerQuantidadeCarrinho(CarrinhoModel p) {
    if (p.item.alimento != null) {
      removeQuantityFood(p);
    } else if (p.item.produto != null) {
      removeQuantityProduct(p);
    }
  }
}
