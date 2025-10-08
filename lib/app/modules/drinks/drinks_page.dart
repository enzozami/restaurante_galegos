import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './drinks_controller.dart';

class DrinksPage extends GetView<DrinksController> {
  const DrinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Drinks'),
          ],
        ),
      ),
    );
  }
}
