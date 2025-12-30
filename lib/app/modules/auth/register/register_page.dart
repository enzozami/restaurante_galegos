import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
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
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/splash/splash.png',
                      height: context.heightTransformer(reducedBy: 65),
                    ),
                    Center(
                      child: SizedBox(
                        width: context.widthTransformer(reducedBy: 10),
                        child: Form(
                          key: controller.formKey,
                          child: Obx(() {
                            return Column(
                              children: [
                                _formFieldsRegister(
                                  context: context,
                                  nameEC: controller.nameEC,
                                  passwordEC: controller.passwordEC,
                                  emailEC: controller.emailEC,
                                  icons: controller.viewConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  onPressed: () {
                                    controller.changePasswordVisibility();
                                  },
                                  obscureText: controller.viewConfirmPassword,
                                ),
                                const SizedBox(height: 30),
                                GalegosButtonDefault(
                                  label: 'Cadastrar',
                                  width: double.infinity,
                                  onPressed: () async {
                                    await controller.register();
                                  },
                                ),
                                const SizedBox(height: 15),
                              ],
                            );
                          }),
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

Widget _passwordValidator(
  BuildContext context,
  ValidationRule rule,
  String value,
) {
  final bool isValid = rule.validate(value);
  final ThemeData theme = Theme.of(context);
  return Row(
    spacing: 10,
    children: [
      Icon(
        isValid ? Icons.check_circle : Icons.cancel,
        color: isValid ? AppColors.delivered : theme.colorScheme.error,
      ),
      Text(
        rule.name,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    ],
  );
}

Widget _formFieldsRegister({
  required BuildContext context,
  required TextEditingController nameEC,
  required TextEditingController passwordEC,
  required TextEditingController emailEC,
  required IconData icons,
  required VoidCallback onPressed,
  required bool obscureText,
}) {
  return Column(
    children: [
      GalegosTextFormField(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        controller: nameEC,
        label: 'Nome completo',
        prefixIcon: Icons.person,
        validator: Validatorless.multiple([
          Validatorless.required('Campo obrigatório'),
        ]),
        prefix: true,
        suffix: false,
      ),
      const SizedBox(height: 15),
      GalegosTextFormField(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        inputType: .emailAddress,
        prefixIcon: Icons.email,
        controller: emailEC,
        label: 'E-mail',
        validator: Validatorless.multiple([
          Validatorless.required('Campo obrigatório'),
          Validatorless.email('E-mail inválido'),
        ]),
        prefix: true,
        suffix: false,
      ),
      const SizedBox(height: 15),
      _fancyPasswordField(context: context, passwordEC: passwordEC),
      const SizedBox(height: 15),
      GalegosTextFormField(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        obscureText: obscureText,
        prefixIcon: Icons.lock,
        onPressed: onPressed,
        suffixIcon: icons,
        label: 'Confirma senha',
        validator: Validatorless.multiple([
          Validatorless.required('Campo obrigatório'),
          Validatorless.compare(passwordEC, 'Senhas diferentes'),
        ]),
        prefix: true,
        suffix: true,
      ),
    ],
  );
}

Widget _fancyPasswordField({
  required BuildContext context,
  required TextEditingController passwordEC,
}) {
  return FancyPasswordField(
    controller: passwordEC,
    keyboardType: .visiblePassword,
    style: TextStyle(color: AppColors.title),
    decoration: InputDecoration(
      label: Text(
        'Senha',
      ),
      prefixIcon: Icon(
        Icons.lock,
        color: AppColors.title,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.title,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.title,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: AppColors.title,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.title,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    ),
    cursorColor: AppColors.title,
    validator: Validatorless.multiple([
      Validatorless.required('Campo obrigatório'),
      Validatorless.min(8, 'Mínimo 8 caracteres'),
    ]),
    validationRules: {
      DigitValidationRule(customText: 'Um número (0-9)'),
      UppercaseValidationRule(customText: 'Uma letra maiúscula (A-Z)'),
      MinCharactersValidationRule(8, customText: '8 caracteres'),
    },
    hasStrengthIndicator: false,
    validationRuleBuilder: (rules, value) {
      return Column(
        crossAxisAlignment: .start,
        spacing: 7,
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'A senha deve conter pelo menos: ',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          ...rules.map(
            (rule) => Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: _passwordValidator(context, rule, value),
            ),
          ),
        ],
      );
    },
  );
}
