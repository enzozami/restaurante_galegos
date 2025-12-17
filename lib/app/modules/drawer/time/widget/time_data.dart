import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/drawer/time/time_controller.dart';

class TimeData extends GetView<TimeController> {
  const TimeData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: context.width,
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'HORÁRIO DE FUNCIONAMENTO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: theme.colorScheme.surface,
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
                        style: theme.textTheme.bodyLarge,
                      ),
                      trailing: Text(
                        '${controller.inicioTime} - ${controller.fimTime}',
                        style: theme.textTheme.titleSmall,
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
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
