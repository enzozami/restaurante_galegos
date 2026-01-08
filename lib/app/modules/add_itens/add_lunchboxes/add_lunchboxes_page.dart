import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import './add_lunchboxes_controller.dart';

class AddLunchboxesPage extends GetView<AddLunchboxesController> {
  const AddLunchboxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(context: context),
      extendBodyBehindAppBar: true,
      body: Container(),
    );
  }
}
