import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
                      'Adicionar Marmita',
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                  Center(
                    child: SectionHeader(
                      items: controller.times
                          .expand((d) => d.days)
                          .map(
                            (day) => MultiSelectCard<String>(
                              value: day,
                              label: day[0],
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          )
                          .toList(),
                      onChanged: controller.onChangedSelectionFunctionEditing,
                    ),
                  ),
                  _formulario(context: context, theme: theme, controller: controller),
                ],
              ),
            );
          }),
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
  return Center(
    child: SizedBox(
      width: context.widthTransformer(reducedBy: 10),
      child: Column(
        spacing: 20,
        children: [
          GalegosTextFormField(
            floatingLabelBehavior: .auto,
            prefix: false,
            suffix: false,
            label: 'Nome da Marmita',
            controller: controller.nomeEC,
            inputType: .text,
            validator: Validatorless.required('Campo obrigatório'),
          ),
          GalegosTextFormField(
            floatingLabelBehavior: .auto,
            prefix: false,
            suffix: false,
            label: 'Descrição',
            controller: controller.descricaoEC,
            maxLines: 5,
            minLines: 3,
            inputType: .text,
          ),
          GalegosTextFormField(
            floatingLabelBehavior: .auto,
            prefix: false,
            suffix: false,
            label: 'Preço Marmita Mini',
            controller: controller.precoMini,
            prefixText: r'R$ ',
            validator: Validatorless.required('Campo obrigatório'),
            inputType: .number,
          ),
          GalegosTextFormField(
            floatingLabelBehavior: .auto,
            prefix: false,
            suffix: false,
            label: 'Preço Marmita Media',
            controller: controller.precoMedia,
            prefixText: r'R$ ',
            inputType: .number,
            validator: Validatorless.required('Campo obrigatório'),
          ),
          SizedBox(
            width: context.widthTransformer(reducedBy: 10),
            child: GalegosButtonDefault(
              label: 'Adicionar',
              onPressed: () async => await controller.cadastrarNovasMarmitas(),
            ),
          ),
        ],
      ),
    ),
  );
}
