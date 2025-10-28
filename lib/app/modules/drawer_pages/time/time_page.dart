import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/time/widgets/time_data.dart';

class TimePage extends GetView<GalegosDrawerController> {
  const TimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(25),
              ),
              width: context.widthTransformer(reducedBy: 10),
              child: TimeData(),
            ),
          ],
        ),
      ),
    );
  }
}
