import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_shimmer.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/modules/drawer/time/time_controller.dart';

class TimePage extends GetView<TimeController> {
  const TimePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: GalegosAppBar(context: context),
      extendBodyBehindAppBar: true,
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: .start,
            children: [
              SafeArea(child: Container()),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 40,
                ),
                child: Text(
                  'Horário de Funcionamento',
                  style: theme.textTheme.headlineLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  'Confira nossos horários de atendimento',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              controller.loading.value
                  ? Center(
                      child: Column(
                        spacing: 20,
                        children: List.generate(
                          6,
                          (_) => CardShimmer(
                            height: 80,
                            width: context.widthTransformer(reducedBy: 10),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: .start,
                        children: controller.dateTime
                            .map(
                              (days) => SizedBox(
                                width: context.widthTransformer(reducedBy: 10),
                                child: Card(
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        spacing: 7,
                                        children: [
                                          Text(
                                            days,
                                            style: theme.textTheme.titleSmall,
                                          ),
                                          (days == controller.dayNow)
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.containerDelivered,
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 5,
                                                    ),
                                                    child: Text(
                                                      'Hoje',
                                                      style: theme.textTheme.labelSmall?.copyWith(
                                                        color: AppColors.delivered,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                                      child: Text(
                                        '${controller.inicioTime} - ${controller.fimTime}',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ),
                                    trailing:
                                        (days == controller.dayNow &&
                                            controller.restauranteAberto.value)
                                        ? Text(
                                            'Aberto',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: AppColors.delivered,
                                            ),
                                          )
                                        : Text(
                                            'Fechado',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: AppColors.error,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
              Center(
                child: Text(
                  'Fazemos entregas em todos os horários de funcionamento!',
                  textAlign: .center,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      }),
    );
  }
}
