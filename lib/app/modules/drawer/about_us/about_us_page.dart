import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/modules/drawer/about_us/widget/about_us_data.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              borderOnForeground: true,
              color: Theme.of(context).colorScheme.secondary,
              child: SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: AboutUsData(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
