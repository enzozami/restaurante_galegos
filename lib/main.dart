import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:restaurante_galegos/app/app_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:restaurante_galegos/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
  final locale = Intl.getCurrentLocale();
  await initializeDateFormatting(locale, null);
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log('Flutter Error: ${details.exception}');
  };
  await GetStorage.init();
  runApp(const AppWidget());
}
