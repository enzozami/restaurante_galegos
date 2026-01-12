import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_shimmer.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_valores.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:validatorless/validatorless.dart';

import 'delivery_address_controller.dart';

class DeliveryAddressPage extends GetView<DeliveryAddressController> {
  const DeliveryAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: GalegosAppBar(context: context),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                  child: Text(
                    'Endereço',
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                Form(
                  key: controller.formKey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: context.widthTransformer(reducedBy: 10),
                            child: GalegosTextFormField(
                              suffixIcon: Icons.backspace_outlined,
                              onPressed: () => controller.resetCepTaxa(),
                              inputType: .numberWithOptions(decimal: true),
                              floatingLabelBehavior: .auto,
                              label: 'CEP',
                              prefixIcon: Icons.location_on,
                              onEditingComplete: controller.canConsultCep
                                  ? () => controller.getCep()
                                  : null,
                              mask: controller.cepFormatter,
                              controller: controller.cepEC,
                              validator: Validatorless.required(
                                'CEP obrigatório',
                              ),
                              onChanged: (value) => controller.cepInput.value = value,
                              prefix: true,
                              suffix: true,
                            ),
                          ),
                          if (!controller.addressValidation())
                            GalegosButtonDefault(
                              label: 'Consultar',
                              width: context.widthTransformer(reducedBy: 10),
                              icon: Icon(
                                Icons.search,
                                color: theme.colorScheme.tertiary,
                              ),
                              onPressed: controller.canConsultCep
                                  ? () => controller.getCep()
                                  : null,
                            )
                          else if (!controller.isOpen.value)
                            Align(
                              alignment: .center,
                              child: IconButton(
                                onPressed: controller.closeCard,
                                icon: const Icon(
                                  Icons.expand_more,
                                ),
                              ),
                            )
                          else
                            (controller.loading.value)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: List.generate(
                                        1,
                                        (_) => CardShimmer(
                                          height: 300,
                                          width: context.widthTransformer(
                                            reducedBy: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    spacing: 20,
                                    children: [
                                      _address(context, controller),
                                      CardValores(
                                        preco: controller.args['preco'],
                                        taxa: controller.taxa.value,
                                        carrinho: false,
                                      ),
                                      Divider(),
                                      GalegosButtonDefault(
                                        label: 'AVANÇAR',
                                        onPressed: () async {
                                          controller.enviarDadosParaPagamento();
                                        },
                                        width: context.widthTransformer(
                                          reducedBy: 10,
                                        ),
                                      ),
                                    ],
                                  ),

                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget _address(BuildContext context, DeliveryAddressController controller) {
  final ThemeData theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Card(
          elevation: 5,
          color: theme.colorScheme.surface,
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
                      prefix: false,
                      suffix: false,
                    ),
                  ),
                ),
                SizedBox(
                  width: context.widthTransformer(reducedBy: 10),
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.bairro.value,
                    inputType: TextInputType.text,
                    prefix: false,
                    suffix: false,
                  ),
                ),
                SizedBox(
                  width: context.widthTransformer(reducedBy: 10),
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.cidade.value,
                    inputType: TextInputType.text,
                    prefix: false,
                    suffix: false,
                  ),
                ),
                SizedBox(
                  // width: 150,
                  width: context.widthTransformer(reducedBy: 60),
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .never,
                    enabled: false,
                    label: controller.estado.value,
                    inputType: TextInputType.text,
                    prefix: false,
                    suffix: false,
                  ),
                ),
                SizedBox(
                  // width: 150,
                  width: context.widthTransformer(reducedBy: 60),
                  child: GalegosTextFormField(
                    floatingLabelBehavior: .auto,
                    enabled: true,
                    prefix: false,
                    suffix: false,
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
        Positioned(
          right: -3,
          top: -3,
          child: IconButton(
            onPressed: () {
              controller.closeCard();
            },
            icon: Icon(Icons.expand_less_outlined),
          ),
        ),
      ],
    ),
  );
}
