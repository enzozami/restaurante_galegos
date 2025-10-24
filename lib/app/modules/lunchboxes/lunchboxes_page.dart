import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_group.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_header.dart';
// import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_header.dart';
import './lunchboxes_controller.dart';

class LunchboxesPage extends GetView<LunchboxesController> {
  const LunchboxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: LunchboxesHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 15),
              child: Text(
                'MARMITAS DE HOJE: \n${controller.dayNow}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(() {
              return Visibility(
                visible:
                    (controller.sizeSelected.value == null || controller.sizeSelected.value == ''),
                child: Column(
                  children: [
                    SizedBox(
                      height: context.heightTransformer(reducedBy: 75),
                    ),
                    Center(
                      child: Text(
                        'Selecione um tamanho*',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            LunchboxesGroup(),
            const SizedBox(
              height: 65,
            ),
          ],
        ),
      ),
    );
  }
}
