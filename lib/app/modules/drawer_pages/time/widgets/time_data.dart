import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';

class TimeData extends GetView<GalegosDrawerController> {
  const TimeData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Text(
            'HORÁRIOS DE FUNCIONAMENTO',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(8.0),
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
          Text(
            'Obs: Domingo e feriados não atendemos!',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }
}
