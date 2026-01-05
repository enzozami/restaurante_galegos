import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import './welcome_controller.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    spacing: 30,
                    children: [
                      Image.asset(
                        'assets/splash/splash.png',
                        height: context.heightTransformer(reducedBy: 50),
                      ),
                      SizedBox(
                        height: context.heightTransformer(reducedBy: 85),
                      ),
                      GalegosButtonDefault(
                        label: 'CADASTRAR',
                        onPressed: () => controller.goToRegister(),
                        width: context.widthTransformer(reducedBy: 10),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      GalegosButtonDefault(
                        label: 'ACESSAR',
                        width: context.widthTransformer(reducedBy: 10),
                        onPressed: () => controller.accessApp(),
                      ),
                      SizedBox(
                        height: context.heightTransformer(reducedBy: 95),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
