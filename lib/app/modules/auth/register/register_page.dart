import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/modules/auth/register/widgets/galegos_check_box.dart';
import 'package:validatorless/validatorless.dart';
import './register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Image.network(
                      'https://restaurantegalegos.wabiz.delivery/stores/restaurantegalegos/img/homeLogo.png?vc=20250915111500&cvc=',
                      fit: BoxFit.cover,
                      width: context.widthTransformer(reducedBy: 10),
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        // key: _formKey,
                        child: Column(
                          children: [
                            GalegosTextFormField(
                              // controller: _usuarioEC,
                              label: 'Nome completo',
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                              ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('CNPJ'),
                                GalegosCheckBox(),
                              ],
                            ),
                            Obx(() {
                              return GalegosTextFormField(
                                // controller: _usuarioEC,
                                label: controller.isChecked.value ? 'CNPJ' : 'CPF',
                                validator: controller.isValidCNPJOrCPF(),
                              );
                            }),
                            const SizedBox(
                              height: 25,
                            ),
                            GalegosTextFormField(
                              // controller: _passwordEC,
                              obscureText: true,
                              label: 'Senha',
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            GalegosTextFormField(
                              // controller: _passwordEC,
                              obscureText: true,
                              label: 'Confirma senha',
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            GalegosButtonDefault(
                              label: 'Cadastrar',
                              onPressed: () {},
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
