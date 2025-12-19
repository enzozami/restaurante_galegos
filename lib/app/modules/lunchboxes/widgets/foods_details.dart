import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';

class FoodsDetails extends GetView<LunchboxesController> {
  const FoodsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(context: context),
      body: Container(),
    );
  }
}
