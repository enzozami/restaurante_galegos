import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/models/card_model.dart';

class FinishedPage extends StatelessWidget {
  final CardModel cardModel = Get.arguments;

  FinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: Center(
        child: Column(
          children: [
            Text(cardModel.productsSelected.length.toString()),
          ],
        ),
      ),
    );
  }
}
