import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';

class ConfigurationPage extends GetView<GalegosDrawerController> {
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: Center(
        child: Column(
          children: [
            Text('Configuration'),
          ],
        ),
      ),
    );
  }
}
