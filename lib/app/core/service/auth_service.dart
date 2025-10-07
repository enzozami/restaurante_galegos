import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';

class AuthService extends GetxService {
  final _isLogged = RxnBool();
  final _getStorage = GetStorage();

  Future<AuthService> init() async {
    _getStorage.listenKey(Constants.USER_KEY, (value) {
      _isLogged(value != null);
    });

    ever(_isLogged, (isLogged) {
      if (isLogged == true) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/auth/login');
      }
    });

    _isLogged(getUserId() != null);
    return this;
  }

  void logout() => _getStorage.write(Constants.USER_KEY, null);

  int? getUserId() => _getStorage.read(Constants.USER_KEY);
}
