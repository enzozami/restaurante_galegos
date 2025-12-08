import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

mixin LoaderMixin on GetxController {
  void loaderListener(RxBool rxLoading) {
    ever(rxLoading, (loading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final isDialogCurrentlyOpen = Get.isDialogOpen ?? false;
        if (loading) {
          if (!isDialogCurrentlyOpen) {
            Get.dialog(
              Center(
                child: LoadingAnimationWidget.progressiveDots(
                  color: GalegosUiDefaut.colorScheme.primary,
                  size: 65,
                ),
              ),
              barrierDismissible: false,
            );
          }
        } else {
          if (isDialogCurrentlyOpen) {
            Get.back();
          }
        }
      });
    });
  }
}
