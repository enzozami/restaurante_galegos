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
  final TimeServices _authServices = Get.find<TimeServices>();

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final dayNow = FormatterHelper.formatDate();

  RxBool get loading => _loading;

  final RxList<String> days = <String>[].obs;
  final inicioTime = ''.obs;
  final fimTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
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
    try {
      _loading.value = true;
      await 1.seconds.delay();
      if (!Get.isRegistered<AuthServicesImpl>()) {
        await Get.putAsync(() async {
          return await AuthServicesImpl(authRepository: Get.find<AuthRepository>()).init();
        });
      }
      _loading.value = false;
      await 100.milliseconds.delay();
      if (Get.currentRoute == '/' && Get.find<AuthServices>().getUserId() == null) {
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
      final timeData = await _authServices.getTime();

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
}
