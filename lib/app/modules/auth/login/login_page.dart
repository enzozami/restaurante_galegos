import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cnpj.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_check_box.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:validatorless/validatorless.dart';
import './login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends GalegosState<LoginPage, LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _usuarioEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

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
                      height: 95,
                    ),
                    Image.network(
                      'https://restaurantegalegos.wabiz.delivery/stores/restaurantegalegos/img/homeLogo.png?vc=20250915111500&cvc=',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Obx(() {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('CNPJ'),
                                  GalegosCheckBox(
                                    isChecked: controller.isChecked.value,
                                    onChanged: (value) {
                                      controller.onSelected(value ?? false);
                                    },
                                  ),
                                ],
                              ),
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                controller: _usuarioEC,
                                inputType: TextInputType.number,
                                mask: (controller.isCpf.value == true) ? MaskCpf() : MaskCnpj(),
                                label: (controller.isCpf.value == true) ? 'CPF' : 'CNPJ',
                                validator: Validatorless.multiple([
                                  Validatorless.required('Campo obrigatório'),
                                  (controller.isCpf.value == true)
                                      ? Validatorless.cpf('CPF inválido')
                                      : Validatorless.cnpj('CNPJ inválido'),
                                ]),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                controller: _passwordEC,
                                obscureText: controller.isSelected.value,
                                icon: IconButton(
                                  onPressed: () {
                                    controller.seePassword();
                                  },
                                  icon: controller.isSelected.value
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                ),
                                validator: Validatorless.multiple([
                                  Validatorless.required('Senha obrigatória'),
                                  Validatorless.min(6, 'Senha deve ter 6 dígitos'),
                                ]),
                                label: 'Senha (Mínimo 6 caracteres)',
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              GalegosButtonDefault(
                                label: 'Entrar',
                                onPressed: () {
                                  final formValid = _formKey.currentState?.validate() ?? false;
                                  if (formValid) {
                                    controller.login(
                                      value: _usuarioEC.text,
                                      password: _passwordEC.text,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.heightTransformer(reducedBy: 85),
                        ),
                        Text(
                          'Não possui cadastro?',
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          style: GalegosUiDefaut.theme.textButtonTheme.style,
                          onPressed: () => Get.toNamed('/auth/register'),
                          child: Text(
                            'Clique aqui',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
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
