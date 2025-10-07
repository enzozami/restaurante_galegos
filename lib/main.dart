import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const AppWidget());
}
