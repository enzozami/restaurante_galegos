import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/drawer/about_us/about_us_controller.dart';

class AboutUsData extends GetView<AboutUsController> {
  const AboutUsData({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      return Column(
        children: [
          Container(
            width: context.width,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.titleAboutUs,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: theme.colorScheme.surface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              controller.textAboutUs,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      );
    });
  }
}
