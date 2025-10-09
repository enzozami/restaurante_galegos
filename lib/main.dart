import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/app_widget.dart';

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log('Flutter Error: ${details.exception}');
  };
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const AppWidget());
}
