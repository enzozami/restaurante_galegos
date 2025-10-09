import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';

class ProductItems extends GetView<ProductsController> {
  final ProductModel modelProduct;

  const ProductItems({
    required this.modelProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            modelProduct.category,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            // onTap: onTap,
            child: Container(
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              width: context.width,
              child: Column(
                children: [
                  ...modelProduct.items.map(
                    (i) => ListTile(
                      title: Text(
                        i.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(i.description ?? ''),
                      trailing: Text('${i.price}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
