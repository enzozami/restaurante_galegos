import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './lunchboxes_controller.dart';

class LunchboxesPage extends GetView<LunchboxesController> {
  const LunchboxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lunchboxes'),
          ],
        ),
      ),
    );
  }
}
