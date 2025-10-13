import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/menu_model.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';

class LunchboxesController extends GetxController with LoaderMixin, MessagesMixin {
  final ScrollController scrollController = ScrollController();
  final LunchboxesServices _lunchboxesServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final menu = <MenuModel>[].obs;
  final alimentos = <AlimentoModel>[].obs;

  final days = <MenuModel>[].obs;

  final dayNow = FormatterHelper.formatDate;

  LunchboxesController({required LunchboxesServices lunchboxesServices})
      : _lunchboxesServices = lunchboxesServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() async {
    super.onReady();
    await getLunchboxes();
  }

  Future<void> getLunchboxes() async {
    _loading.toggle();
    final dayData = await _lunchboxesServices.getData();
    days.assignAll(dayData);

    final getAlimentos = await _lunchboxesServices.getFood();
    alimentos.where((e) => e.dayName == dayNow).toList().assignAll(getAlimentos);

    _loading.toggle();
  }
}

class ScrollController {}
