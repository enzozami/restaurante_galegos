import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/alimentos_widget.dart';

class LunchboxesGroup extends GetView<LunchboxesController> {
  const LunchboxesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        final alimentos = controller.alimentos;
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 5,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: alimentos.length,
          itemBuilder: (context, index) {
            final alimento = alimentos[index];
            return Column(
              children: [
                AlimentosWidget(
                  alimentoModel: alimento,
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
