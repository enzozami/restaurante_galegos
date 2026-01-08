import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './add_products_controller.dart';

class AddProductsPage extends GetView<AddProductsController> {
  const AddProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddProductsPage'),
      ),
      body: Container(),
    );
  }
}
