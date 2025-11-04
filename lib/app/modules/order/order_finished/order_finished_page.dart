import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './order_finished_controller.dart';

class OrderFinishedPage extends GetView<OrderFinishedController> {
  const OrderFinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Order Finished Page'),
      ),
    );
  }
}
