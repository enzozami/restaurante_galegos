import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/button_tag.dart';

class LunchboxesHeader extends GetView<LunchboxesController> {
  const LunchboxesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          final day = controller.days;

          return Row(
            children: day
                .map(
                  (d) => ButtonTag(
                    model: d,
                    onPressed: () {},
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}
