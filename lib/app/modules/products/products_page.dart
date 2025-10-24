import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/product_header.dart';
import 'package:restaurante_galegos/app/modules/products/widgets/products_group.dart';
import './products_controller.dart';

class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller.scrollController,
        // physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            ProductHeader(),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Selecione algum item para adicionar ao carrinho*',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
            ),
            ProductsGroup(
              scrollController: controller.scrollController,
            ),
          ],
        ),
      ),
    );
  }
}
