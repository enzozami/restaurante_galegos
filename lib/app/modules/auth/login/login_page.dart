import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:validatorless/validatorless.dart';

import './login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
                        key: controller.formKeyLogin,
                        child: Obx(() {
                          return Column(
                            children: [
                              _formFieldsLogin(
                                emailEC: controller.emailEC,
                                passwordEC: controller.passwordEC,
                                context: context,
                                icons: controller.viewPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                onPressed: () {
                                  controller.changePasswordVisibility();
                                },
                                obscureText: controller.viewPassword,
                                onEditingComplete: () async {
                                  await controller.login();
                                },
                              ),
                              const SizedBox(height: 25),
                              GalegosButtonDefault(
                                label: 'Entrar',
                                onPressed: () async {
                                  await controller.login();
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
                        SizedBox(
                          height: context.heightTransformer(reducedBy: 85),
                        ),
                        Text(
                          'Não possui cadastro?',
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          style: theme.textButtonTheme.style,
                          onPressed: () => Get.toNamed('/auth/register'),
                          child: Text(
                            'Clique aqui',
                            style: TextStyle(fontSize: 15),
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

Widget _formFieldsLogin({
  required TextEditingController emailEC,
  required TextEditingController passwordEC,
  required BuildContext context,
  required IconData icons,
  required VoidCallback onPressed,
  required bool obscureText,
  required VoidCallback onEditingComplete,
}) {
  return Column(
    children: [
      GalegosTextFormField(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        controller: emailEC,
        inputType: .emailAddress,
        prefixIcon: Icon(Icons.email),
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
        prefixIcon: Icon(Icons.lock),
        textInputAction: .done,
        onEditingComplete: onEditingComplete,
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

class _AlertResetPassword extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Form(
      key: controller.formKeyReset,
      child: AlertDialog(
        contentPadding: EdgeInsets.all(30),
        icon: Align(
          alignment: .centerRight,
          child: Icon(Icons.close, color: theme.colorScheme.tertiary),
        ),
        title: Text(
          'Restaurar senha',
          style: theme.textTheme.titleLarge,
          textAlign: .center,
        ),
        content: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              Text(
                'Digite o e-mail referente a conta para restaurar a senha',
                textAlign: .justify,
                style: theme.textTheme.bodyLarge,
              ),
              GalegosTextFormField(
                floatingLabelBehavior: .auto,
                inputType: .emailAddress,
                controller: controller.emailEC,
                colorBorder: theme.colorScheme.tertiary,
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
              controller.senhaNova();
            },
          ),
        ],
      ),
    );
  }
}
