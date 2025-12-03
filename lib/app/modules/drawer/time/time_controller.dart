import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';

class TimeController extends GetxController with LoaderMixin, MessagesMixin {
  final TimeServices _timeServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _isSelected = false.obs;
  final _dateTime = <String>[].obs;
  final _inicioTime = ''.obs;
  final _fimTime = ''.obs;

  final dayNow = FormatterHelper.formatDate();

  bool get isSelected => _isSelected.value;
  set isSelected(bool value) => _isSelected.value = value;
  List<String> get dateTime => _dateTime.value;
  String get inicioTime => _inicioTime.value;
  String get fimTime => _fimTime.value;

  TimeController({required TimeServices timeServices}) : _timeServices = timeServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    time();
  }

  Future<void> time() async {
    _loading(true);
    final timeData = await _timeServices.getTime();

    final data = timeData.where((e) => e.days.contains(dayNow));

    _dateTime.assignAll(data.first.days);
    _inicioTime.value = data.first.inicio;
    _fimTime.value = data.first.fim;
  }
}
