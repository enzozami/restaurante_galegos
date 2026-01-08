import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/section_header.dart';
import 'package:validatorless/validatorless.dart';
import './add_lunchboxes_controller.dart';

class AddLunchboxesPage extends GetView<AddLunchboxesController> {
  const AddLunchboxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: GalegosAppBar(context: context),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: context.widthTransformer(reducedBy: 10),
            child: Column(
              spacing: 20,
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                  child: Text(
                    'Adicionar Marmita',
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                _formulario(context: context, theme: theme, controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _formulario({
  required BuildContext context,
  required ThemeData theme,
  required AddLunchboxesController controller,
}) {
  return Obx(() {
    return Form(
      key: controller.formKey,
      child: Center(
        child: SizedBox(
          width: context.widthTransformer(reducedBy: 10),
          child: Column(
            spacing: 20,
            mainAxisAlignment: .center,
            children: [
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Nome do Produto',
                validator: Validatorless.required('Campo obrigatório'),
                // controller: controller.nameEC,
                prefix: false,
                suffix: false,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                label: 'Descrição',
                // controller: controller.descriptionEC,
                prefix: false,
                suffix: false,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                enabled: true,
                inputType: .number,
                validator: Validatorless.required('Campo obrigatório'),
                label: 'Preço',
                prefixText: r'R$ ',
                // controller: controller.priceEC,
                prefix: false,
                suffix: false,
              ),
              SizedBox(
                width: context.widthTransformer(reducedBy: 10),
                child: GalegosButtonDefault(
                  label: 'Adicionar',
                  onPressed: () async => controller.cadastrarNovasMarmitas(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}
