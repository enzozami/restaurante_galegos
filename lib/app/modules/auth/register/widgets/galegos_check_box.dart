import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:restaurante_galegos/app/core/enums/galegos_enum.dart';
import 'package:restaurante_galegos/app/modules/auth/register/register_controller.dart';

class GalegosCheckBox extends GetView<RegisterController> {
  const GalegosCheckBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var isChecked = (controller.type.value == GalegosEnum.cpf) ? false : true;

      return Checkbox(
        checkColor: Colors.amber,
        side: BorderSide(
          color: Colors.black,
        ),
        value: isChecked,
        onChanged: (value) {
          controller.type.value = value! ? GalegosEnum.cnpj : GalegosEnum.cpf;
        },
      );
    });
  }
}
