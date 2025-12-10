import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_valores.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/card_shimmer.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:validatorless/validatorless.dart';
import './address_controller.dart';

class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                child: Text('Endereço', style: GalegosUiDefaut.theme.textTheme.titleLarge),
              ),
              Form(
                key: controller.formKey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 10,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GalegosTextFormField(
                            icon: IconButton(
                              onPressed: () {
                                controller.resetCepTaxa();
                              },
                              icon: Icon(Icons.backspace_outlined),
                            ),
                            inputType: .numberWithOptions(decimal: true),
                            floatingLabelBehavior: .auto,
                            label: 'CEP',
                            prefixIcon: Icon(Icons.location_on),
                            onEditingComplete: controller.validationOnReplacement()
                                ? () {
                                    controller.getCep();
                                  }
                                : null,
                            mask: controller.cepFormatter,
                            controller: controller.cepEC,
                            validator: Validatorless.required('CEP obrigatório'),
                            onChanged: (value) => controller.cepInput.value = value,
                          ),
                        ),
                        controller.loading.value
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: List.generate(
                                    1,
                                    (_) => CardShimmer(
                                      height: 250,
                                      width: context.widthTransformer(reducedBy: 15),
                                    ),
                                  ),
                                ),
                              )
                            : Visibility(
                                visible: controller.addressValidation(),
                                replacement: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: context.widthTransformer(reducedBy: 10),
                                    child: GalegosButtonDefault(
                                      label: 'Consultar',
                                      icon: Icon(
                                        Icons.search,
                                        color: GalegosUiDefaut.colorScheme.tertiary,
                                      ),
                                      onPressed: controller.validationOnReplacement()
                                          ? () {
                                              controller.getCep();
                                              controller.isOpen.value = true;
                                            }
                                          : null,
                                    ),
                                  ),
                                ),
                                child: _address(context, controller),
                              ),
                        const SizedBox(height: 15),
                        controller.loading.value
                            ? Stack(
                                children: List.generate(
                                  1,
                                  (_) => CardShimmer(
                                    height: 110,
                                    width: context.widthTransformer(reducedBy: 35),
                                  ),
                                ),
                              )
                            : Visibility(
                                visible: controller.addressValidation(),
                                child: Center(
                                  child: CardValores(
                                    preco: controller.preco,
                                    taxa: controller.taxa.value,
                                    carrinho: false,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget _address(BuildContext context, AddressController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Card(
          elevation: 5,
          color: GalegosUiDefaut.colors['fundo'],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: .spaceAround,
              crossAxisAlignment: .center,
              spacing: 10,
              runSpacing: 10,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: SizedBox(
                    width: context.widthTransformer(reducedBy: 10),
                    child: GalegosTextFormField(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabled: false,
                      label: controller.rua.value,
                      inputType: TextInputType.text,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.bairro.value,
                    inputType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.cidade.value,
                    inputType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.estado.value,
                    inputType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .auto,
                    enabled: true,
                    label: 'Número*',
                    focusNode: controller.numeroFocus,
                    inputType: .numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    maxLength: 6,
                    buildCounter:
                        (
                          context, {
                          required currentLength,
                          required isFocused,
                          required maxLength,
                        }) => SizedBox.shrink(),
                    maxLengthEnforcement: .enforced,
                    controller: controller.numeroEC,
                    validator: Validatorless.required('Número obrigatório'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
