import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_shimmer.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/modules/drawer/about_us/about_us_controller.dart';

class AboutUsPage extends GetView<AboutUsController> {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: GalegosAppBar(context: context),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return Form(
              key: controller.formKey,
              child: Column(
                spacing: 20,
                crossAxisAlignment: .start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                    child: Text(
                      'Sobre nós',
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),

                  controller.loading.value
                      ? Center(
                          child: Column(
                            spacing: 20,
                            children: List.generate(
                              3,
                              (_) => CardShimmer(
                                height: 300,
                                width: context.widthTransformer(reducedBy: 10),
                              ),
                            ),
                          ),
                        )
                      : Column(
                          spacing: 20,
                          children: [
                            controller.admin
                                ? formQuemSomos(
                                    context: context,
                                    title: 'Quem somos',
                                    theme: theme,
                                    image:
                                        'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/b0/67/9c/photo1jpg.jpg?w=900&h=500&s=1',
                                    controller: controller,
                                  )
                                : _cards(
                                    context: context,
                                    title: 'Quem somos',
                                    image:
                                        'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/b0/67/9c/photo1jpg.jpg?w=900&h=500&s=1',
                                    text: controller.quemSomos.value,
                                    theme: theme,
                                  ),
                            controller.admin
                                ? formFilosofia(
                                    context: context,
                                    controller: controller,
                                    title: 'Nossa filosofia',
                                    theme: theme,
                                  )
                                : _cards(
                                    context: context,
                                    title: 'Nossa filosofia',

                                    text: controller.filosofia.value,
                                    theme: theme,
                                  ),
                            controller.admin
                                ? formPorqueNos(
                                    context: context,
                                    title: 'Por que escolher nós',
                                    controller: controller,
                                    theme: theme,
                                  )
                                : _cardForChooseUs(
                                    context: context,
                                    title: 'Por que escolher nós?',
                                    text: controller.porqueNos.value,
                                    buffet: controller.buffet.value,
                                    service: controller.servicos.value,
                                    lunchboxes: controller.marmitas.value,
                                    theme: theme,
                                  ),
                          ],
                        ),

                  controller.admin
                      ? Row(
                          mainAxisAlignment: .spaceAround,
                          children: [
                            Center(
                              child: GalegosButtonDefault(
                                width: context.widthTransformer(reducedBy: 60),
                                style: theme.elevatedButtonTheme.style?.copyWith(
                                  backgroundColor: WidgetStatePropertyAll<Color>(
                                    theme.colorScheme.error,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll<Color>(
                                    theme.colorScheme.onError,
                                  ),
                                ),
                                label: 'Cancelar',
                                onPressed: () => controller.desfazerAlteracoes(),
                              ),
                            ),
                            Center(
                              child: GalegosButtonDefault(
                                width: context.widthTransformer(reducedBy: 60),
                                label: 'Salvar',
                                onPressed: () async => await controller.atualizarDados(),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

Widget _cards({
  required BuildContext context,
  required String title,
  required String text,
  required ThemeData theme,
  String? image,
}) {
  return Center(
    child: SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 15,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              image != null
                  ? Image.network(
                      image,
                    )
                  : SizedBox.shrink(),
              Text(
                text,
                textAlign: .justify,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _cardForChooseUs({
  required BuildContext context,
  required String title,
  required String text,
  required String buffet,
  required String service,
  required String lunchboxes,
  required ThemeData theme,
}) {
  return Center(
    child: SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 25,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              Text(
                text,
                textAlign: .justify,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      '- $buffet',
                      textAlign: .justify,
                    ),
                    Text(
                      '- $service',
                      textAlign: .justify,
                    ),
                    Text(
                      '- $lunchboxes',
                      textAlign: .justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget formQuemSomos({
  required BuildContext context,
  required AboutUsController controller,
  required String title,
  required ThemeData theme,
  String? image,
}) {
  return Center(
    child: SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 15,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              image != null
                  ? Image.network(
                      image,
                    )
                  : SizedBox.shrink(),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                prefix: false,
                suffix: false,
                controller: controller.newQuemSomosEC,
                inputType: .text,
                maxLines: controller.quemSomos.value.length,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget formFilosofia({
  required BuildContext context,
  required AboutUsController controller,
  required String title,
  required ThemeData theme,
}) {
  return Center(
    child: SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 15,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                prefix: false,
                suffix: false,
                controller: controller.newFilosofia,
                maxLines: controller.filosofia.value.length,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget formPorqueNos({
  required BuildContext context,
  required String title,
  required AboutUsController controller,
  required ThemeData theme,
}) {
  return Center(
    child: SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 25,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                prefix: false,
                suffix: false,
                maxLines: controller.porqueNos.value.length,
                controller: controller.newPorqueNos,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: .start,
                  children: [
                    GalegosTextFormField(
                      floatingLabelBehavior: .auto,
                      prefix: false,
                      suffix: false,
                      maxLines: controller.buffet.value.length,
                      controller: controller.newBuffet,
                    ),
                    GalegosTextFormField(
                      floatingLabelBehavior: .auto,
                      prefix: false,
                      suffix: false,
                      maxLines: controller.servicos.value.length,
                      controller: controller.newServicos,
                    ),
                    GalegosTextFormField(
                      floatingLabelBehavior: .auto,
                      prefix: false,
                      suffix: false,
                      maxLines: controller.marmitas.value.length,
                      controller: controller.newMarmitas,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
