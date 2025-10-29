import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';

class AuthService extends GetxService {
  final _isLogged = RxnBool();
  final _getStorage = GetStorage();

  bool canUseApp() {
    if (kDebugMode) return true;
    var timeNow = DateTime.now();

    final inicio = DateTime(timeNow.year, timeNow.month, timeNow.day, 9, 0);
    final fim = DateTime(timeNow.year, timeNow.month, timeNow.day, 14, 50);

    return inicio.isBefore(timeNow) && fim.isAfter(timeNow);
  }

  Future<AuthService> init() async {
    if (canUseApp()) {
      _getStorage.listenKey(Constants.USER_KEY, (value) {
        _isLogged(value != null);
      });

      ever(_isLogged, (isLogged) {
        if (isLogged == null || !isLogged) {
          Get.offAllNamed('/auth/login');
        } else {
          Get.offAllNamed('/home');
        }
      });

      _isLogged(getUserId() != null);
      return this;
    } else {
      Get.snackbar(
        'Fora do horário de funcionamento',
        'Nós funcionamos das 09:00 às 14:50h!',
        duration: 3.seconds,
        backgroundColor: Colors.amberAccent,
      );
      return this;
    }
  }

  void logout() => _getStorage.write(Constants.USER_KEY, null);

  int? getUserId() => _getStorage.read(Constants.USER_KEY);
}
