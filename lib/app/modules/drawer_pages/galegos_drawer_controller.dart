import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/services/user/user_services.dart';

class GalegosDrawerController extends GetxController with LoaderMixin, MessagesMixin {
  final UserServices _userServices;
  final AuthService _authService;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _isSelected = false.obs;
  final _isObscure = true.obs;

  bool get isSelected => _isSelected.value;
  bool get isObscure => _isObscure.value;

  var name = ''.obs;
  var password = ''.obs;
  final valueCpfOrCnpj = ''.obs;

  GalegosDrawerController({
    required UserServices userServices,
    required AuthService authService,
  })  : _userServices = userServices,
        _authService = authService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    getUser();
  }

  void isSelect() {
    _isSelected.toggle();
  }

  void obscure() {
    _isObscure.toggle();
  }

  Future<void> getUser() async {
    final userId = _authService.getUserId();
    if (userId != null) {
      final userData = await _userServices.getUser(id: userId);
      name.value = userData.name;
      password.value = userData.password;
      valueCpfOrCnpj.value = userData.value;
    }
  }
}
