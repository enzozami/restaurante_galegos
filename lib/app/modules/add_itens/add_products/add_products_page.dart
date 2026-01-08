import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:validatorless/validatorless.dart';
import './add_products_controller.dart';

class AddProductsPage extends GetView<AddProductsController> {
  const AddProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: GalegosAppBar(context: context),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          spacing: 10,
          children: [
            SafeArea(child: Container()),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
              child: Text(
                'Adicionar Produto',
                style: theme.textTheme.headlineLarge,
              ),
            ),
            _formulario(context: context, theme: theme, controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _formulario({
    required BuildContext context,
    required ThemeData theme,
    required AddProductsController controller,
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
                DropdownButtonFormField<String>(
                  items: controller.categoryList.value
                      .map(
                        (cat) => DropdownMenuItem<String>(
                          value: cat.name,
                          child: Text(cat.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.changeDropdown(value);
                    }
                  },

                  hint: Text(
                    'Selecione uma categoria',
                    style: theme.textTheme.titleSmall,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: AppColors.title,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.title,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: AppColors.title,
                      ),
                    ),
                  ),
                  validator: Validatorless.required('Campo obrigatório'),
                ),
                GalegosTextFormField(
                  floatingLabelBehavior: .auto,
                  label: 'Nome do Produto',
                  validator: Validatorless.required('Campo obrigatório'),
                  controller: controller.nameEC,
                  prefix: false,
                  suffix: false,
                ),
                GalegosTextFormField(
                  floatingLabelBehavior: .auto,
                  label: 'Descrição',
                  controller: controller.descriptionEC,
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
                  controller: controller.priceEC,
                  prefix: false,
                  suffix: false,
                ),
                SizedBox(
                  width: context.widthTransformer(reducedBy: 10),
                  child: GalegosButtonDefault(
                    label: 'Adicionar',
                    onPressed: () async => await controller.cadastrarNovosProdutos(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
