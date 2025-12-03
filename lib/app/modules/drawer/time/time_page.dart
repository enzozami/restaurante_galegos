import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/modules/drawer/time/time_controller.dart';
import 'package:restaurante_galegos/app/modules/drawer/time/widget/time_data.dart';

class TimePage extends GetView<TimeController> {
  const TimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              borderOnForeground: true,
              color: GalegosUiDefaut.colorScheme.secondary,
              child: SizedBox(width: context.widthTransformer(reducedBy: 10), child: TimeData()),
            ),
          ],
        ),
      ),
    );
  }
}
