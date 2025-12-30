import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';

mixin LoaderMixin on GetxController {
  void loaderListener(RxBool rxLoading) {
    ever<bool>(rxLoading, (loading) async {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final isDialogCurrentlyOpen = Get.isDialogOpen ?? false;
        if (loading) {
          if (!isDialogCurrentlyOpen) {
            Get.dialog(
              PopScope(
                canPop: false,
                child: Center(
                  child: LoadingAnimationWidget.progressiveDots(
                    color: AppColors.primary,
                    size: 65,
                  ),
                ),
              ),
              barrierDismissible: false,
              name: 'loader-dialog',
            );
          }
        } else {
          if (isDialogCurrentlyOpen) {
            Get.until((route) => !Get.isDialogOpen!);
            // Get.back();
          }
        }
      });
    });
  }
}
