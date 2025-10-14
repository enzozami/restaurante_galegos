import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/button_tag.dart';

class LunchboxesHeader extends GetView<LunchboxesController> {
  const LunchboxesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: controller.sizes.length,
          itemBuilder: (context, index) {
            return ButtonTag(
              model: controller.sizes[index],
              onPressed: () {},
            );
          },
        );
      }),
    );
  }
}
