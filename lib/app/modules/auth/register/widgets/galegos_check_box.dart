import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:restaurante_galegos/app/modules/auth/register/register_controller.dart';

class GalegosCheckBox extends GetView<RegisterController> {
  const GalegosCheckBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Checkbox(
        checkColor: Colors.amber,
        side: BorderSide(
          color: Colors.black,
        ),
        value: controller.isChecked,
        onChanged: (value) {
          if (value != null) {
            controller.onSelected(value);
          }
        },
      );
    });
  }
}
