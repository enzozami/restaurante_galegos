import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/enums/galegos_enum.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class LoginController extends GetxController with LoaderMixin {
  final AuthServices _authServices;
  final _loading = false.obs;
  final type = GalegosEnum.cpf.obs;
  final typeMask = MaskCpf().obs;

  LoginController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
  }

  void onSelected(GalegosEnum value) {
    type.value = value;
  }

  Future<void> login({
    required String user,
    required String password,
  }) async {
    _loading.toggle();
    await _authServices.login(user, type.value, password);
    _loading.toggle();
  }
}
