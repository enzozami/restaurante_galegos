import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';

class TimeData extends GetView<GalegosDrawerController> {
  const TimeData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.width,
          decoration: BoxDecoration(
            color: GalegosUiDefaut.colorScheme.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'HORÁRIOS DE FUNCIONAMENTO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Obx(() {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: controller.dateTime
                  .map(
                    (d) => ListTile(
                      title: Text(
                        d,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      trailing: Text(
                        '${controller.inicioTime} - ${controller.fimTime}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Obs: Domingo e feriados não atendemos!',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      ],
    );
  }
}
