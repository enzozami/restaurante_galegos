import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:restaurante_galegos/app/models/day_model.dart';
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
          final menus = controller.menu;

          final menuDay = menus.map((e) => e).toList();
          log('$menuDay');

          for (var menu in menuDay) {
            final listData = [
              ...menu.day.map((e) {
                return Row(
                  children: ButtonTag(model: e, onPressed: () {}),
                );
              })
            ];
          }
        }),
      ),
    );
  }
}
