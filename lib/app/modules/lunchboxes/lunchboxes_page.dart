import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_group.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_header.dart';
// import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_header.dart';
import './lunchboxes_controller.dart';

class LunchboxesPage extends GetView<LunchboxesController> {
  const LunchboxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LunchboxesHeader(),
            LunchboxesGroup(),
          ],
        ),
      ),
    );
  }
}
