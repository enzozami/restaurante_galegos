import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './products_controller.dart';

class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Products'),
          ],
        ),
      ),
    );
  }
}
