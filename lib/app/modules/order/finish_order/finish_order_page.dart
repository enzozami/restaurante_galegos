import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './finish_order_controller.dart';

class FinishOrderPage extends GetView<FinishOrderController> {
  const FinishOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinishOrderPage'),
      ),
      body: Container(),
    );
  }
}
