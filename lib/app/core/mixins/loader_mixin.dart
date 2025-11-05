import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin LoaderMixin on GetxController {
  void loaderListener(RxBool rxLoading) {
    ever(
      rxLoading,
      (loading) async {
        if (loading) {
          await Get.dialog(
            Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE2933C),
              ),
            ),
            barrierDismissible: false,
          );
        } else {
          Get.back();
        }
      },
    );
  }
}
