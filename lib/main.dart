import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:restaurante_galegos/app/app_widget.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locale = Intl.getCurrentLocale();
  await initializeDateFormatting(locale, null);
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log('Flutter Error: ${details.exception}');
  };
  await GetStorage.init();
  runApp(const AppWidget());
}
