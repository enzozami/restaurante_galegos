import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_shimmer.dart';
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
          mainAxisAlignment: .center,
          children: [
            controller.loading.value
                ? Wrap(
                    alignment: .center,
                    children: List.generate(
                      1,
                      (_) => CardShimmer(
                        height: 508,
                        width: context.widthTransformer(reducedBy: 10),
                      ),
                    ),
                  )
                : Card(
                    elevation: 5,
                    borderOnForeground: true,
                    color: Theme.of(context).colorScheme.secondary,
                    child: SizedBox(
                      width: context.widthTransformer(reducedBy: 10),
                      child: TimeData(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
