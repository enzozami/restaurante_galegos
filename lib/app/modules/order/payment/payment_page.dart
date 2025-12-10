import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './payment_controller.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaymentPage'),
      ),
      body: Container(),
    );
  }
}
