import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

mixin LoaderMixin on GetxController {
  void loaderListener(RxBool rxLoading) {
    ever(rxLoading, (loading) async {
      if (loading) {
        if (!Get.isDialogOpen!) {
          await Get.dialog(
            Center(
              child: LoadingAnimationWidget.progressiveDots(
                color: GalegosUiDefaut.colorScheme.primary,
                size: 75,
              ),
            ),
            barrierDismissible: false,
          );
        }
      } else {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      }
    });
  }
}
