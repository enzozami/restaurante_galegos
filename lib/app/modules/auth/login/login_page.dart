import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
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
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    const SizedBox(height: 95),
                    Image.network(
                      'https://restaurantegalegos.wabiz.delivery/stores/restaurantegalegos/img/homeLogo.png?vc=20250915111500&cvc=',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 120),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Obx(() {
                          return Column(
                            children: [
                              _formFieldsLogin(
                                emailEC: _emailEC,
                                passwordEC: _passwordEC,
                                context: context,
                                icons: controller.isSelected.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                onPressed: () {
                                  controller.seePassword();
                                },
                                obscureText: controller.isSelected.value,
                              ),
                              const SizedBox(height: 25),
                              GalegosButtonDefault(
                                label: 'Entrar',
                                onPressed: () {
                                  final formValid = _formKey.currentState?.validate() ?? false;
                                  if (formValid) {
                                    controller.login(
                                      value: _emailEC.text,
                                      password: _passwordEC.text,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 15),
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
                        SizedBox(height: context.heightTransformer(reducedBy: 85)),
                        Text('Não possui cadastro?', style: TextStyle(fontSize: 15)),
                        TextButton(
                          style: GalegosUiDefaut.theme.textButtonTheme.style,
                          onPressed: () => Get.toNamed('/auth/register'),
                          child: Text('Clique aqui', style: TextStyle(fontSize: 15)),
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

Widget _formFieldsLogin({
  required TextEditingController emailEC,
  required TextEditingController passwordEC,
  required BuildContext context,
  required IconData icons,
  required VoidCallback onPressed,
  required bool obscureText,
}) {
  return Column(
    children: [
      GalegosTextFormField(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        controller: emailEC,
        inputType: .emailAddress,
        label: 'E-mail',
        validator: Validatorless.multiple([
          Validatorless.required('Campo obrigatório'),
          Validatorless.email('E-mail inválido'),
        ]),
      ),
      const SizedBox(height: 25),
      GalegosTextFormField(
        floatingLabelBehavior: .auto,
        controller: passwordEC,
        obscureText: obscureText,
        inputType: .visiblePassword,
        icon: IconButton(
          onPressed: onPressed,
          icon: Icon(icons),
        ),
        validator: Validatorless.multiple([
          Validatorless.required('Senha obrigatória'),
          Validatorless.min(8, 'Senha deve ter 8 dígitos'),
        ]),
        label: 'Senha',
      ),
      Align(
        alignment: .centerRight,
        child: TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return _AlertResetPassword();
              },
            );
          },
          child: Text('Esqueci minha senha'),
        ),
      ),
    ],
  );
}

class _AlertResetPassword extends StatefulWidget {
  const _AlertResetPassword();

  @override
  State<_AlertResetPassword> createState() => _AlertResetPasswordState();
}

class _AlertResetPasswordState extends GalegosState<_AlertResetPassword, LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        contentPadding: EdgeInsets.all(30),
        icon: Align(
          alignment: .centerRight,
          child: Icon(Icons.close, color: GalegosUiDefaut.colorScheme.tertiary),
        ),
        title: Text(
          'Restaurar senha',
          style: GalegosUiDefaut.theme.textTheme.titleLarge,
          textAlign: .center,
        ),
        content: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              Text(
                'Digite o e-mail referente a conta para restaurar a senha',
                textAlign: .justify,
                style: GalegosUiDefaut.theme.textTheme.bodyLarge,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                inputType: .emailAddress,
                controller: _emailEC,
                colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                label: 'E-mail',
                validator: Validatorless.multiple([
                  Validatorless.required('E-mail obrigatório'),
                  Validatorless.email('E-mail inválido'),
                ]),
              ),
            ],
          ),
        ),
        actionsAlignment: .center,
        actions: [
          GalegosButtonDefault(
            label: 'Enviar',
            onPressed: () {
              final formValid = _formKey.currentState?.validate() ?? false;
              if (formValid) {
                controller.senhaNova(email: _emailEC.text);
                log('Mensagem enviada');
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }
}
