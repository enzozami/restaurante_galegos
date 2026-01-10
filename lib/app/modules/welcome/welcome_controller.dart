import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services_impl.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';

class WelcomeController extends GetxController with LoaderMixin, MessagesMixin {
  final TimeServices _timeServices = Get.find<TimeServices>();
  AuthServices get _authServices => Get.find<AuthServices>();

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final dayNow = FormatterHelper.formatDate();
  final open = false.obs;

  RxBool get loading => _loading;

  final RxList<String> days = <String>[].obs;
  final inicioTime = ''.obs;
  final fimTime = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
    horarioFuncionamento();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _isOpenOrClosed();
  }

  void goToLogin() => Get.toNamed('/auth/login');
  Future<void> goToRegister() async {
    _loading.value = true;
    await 500.milliseconds.delay();
    _loading.value = false;
    await 100.milliseconds.delay();
    Get.toNamed('/auth/register');
  }

  Future<void> accessApp() async {
    if (_loading.value) return;
    try {
      _loading.value = true;
      await 1.seconds.delay();

      if (!open.value) {
        _loading.value = false;
        await Future.delayed(Duration(milliseconds: 100));
        Get.toNamed('horarioFuncionamento');
        return;
      }
      if (!Get.isRegistered<AuthServicesImpl>()) {
        await Get.putAsync(() async {
          return await AuthServicesImpl(authRepository: Get.find<AuthRepository>()).init();
        });
      }
      _loading.value = false;
      await 100.milliseconds.delay();
      if (Get.currentRoute == '/' && _authServices.getUserId() == null) {
        goToLogin();
      }
    } catch (e, s) {
      _loading.value = false;
      log(e.toString());
      log(s.toString());
      _message.value = MessageModel(
        title: 'Erro',
        message: 'Erro ao inicializar AuthServices',
        type: MessageType.error,
      );
    } finally {
      _loading.value = false;
    }
  }

  Future<void> horarioFuncionamento() async {
    try {
      final timeData = await _timeServices.getTime();

      final data = timeData.where((e) => e.days.contains(dayNow));

      days.assignAll(data.first.days);

      inicioTime.value = data.first.inicio;
      fimTime.value = data.first.fim;
    } catch (e, s) {
      _loading.value = false;
      log('Erro ao carregar horário de funcionamento', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao carregar horário de funcionamento',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _isOpenOrClosed() async {
    final value = await _authServices.openOrClosedRestaurant();
    open.value = value;
  }
}
