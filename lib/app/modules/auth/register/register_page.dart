import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:validatorless/validatorless.dart';
import './register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends GalegosState<RegisterPage, RegisterController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameEC.dispose();
    _passwordEC.dispose();
    _emailEC.dispose();
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 75),
                    Image.network(
                      'https://restaurantegalegos.wabiz.delivery/stores/restaurantegalegos/img/homeLogo.png?vc=20250915111500&cvc=',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Obx(() {
                          return Column(
                            children: [
                              _formFieldsRegister(
                                context: context,
                                nameEC: _nameEC,
                                passwordEC: _passwordEC,
                                emailEC: _emailEC,
                                icons: controller.isSelectedConfirmaSenha.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                onPressed: () {
                                  controller.seeConfirmPassword();
                                },
                                obscureText: controller.isSelectedConfirmaSenha.value,
                              ),
                              const SizedBox(height: 20),
                              GalegosButtonDefault(
                                label: 'Cadastrar',
                                onPressed: () {
                                  final formValid = _formKey.currentState?.validate() ?? false;
                                  if (formValid) {
                                    controller.register(
                                      name: _nameEC.text,
                                      password: _passwordEC.text,
                                      email: _emailEC.text,
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

Widget _passwordValidator(BuildContext context, ValidationRule rule, String value) {
  final bool isValid = rule.validate(value);

  return Row(
    spacing: 10,
    children: [
      Icon(
        isValid ? Icons.check_circle : Icons.cancel,
        color: isValid ? const Color(0xFF36A739) : GalegosUiDefaut.colorScheme.error,
      ),
      Text(rule.name),
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
        validator: Validatorless.multiple([
          Validatorless.required('Campo obrigatório'),
        ]),
      ),
      const SizedBox(height: 15),
      GalegosTextFormField(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        inputType: .emailAddress,
        controller: emailEC,
        label: 'E-mail',
        validator: Validatorless.multiple([
          Validatorless.required('Senha obrigatória'),
          Validatorless.email('E-mail inválido'),
        ]),
      ),
      const SizedBox(height: 15),
      _fancyPasswordField(context: context, passwordEC: passwordEC),
      const SizedBox(height: 15),
      GalegosTextFormField(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        obscureText: obscureText,
        icon: IconButton(
          onPressed: onPressed,
          icon: Icon(icons),
        ),
        label: 'Confirma senha',
        validator: Validatorless.multiple([
          Validatorless.required('Confirma senha obrigatória'),
          Validatorless.compare(passwordEC, 'Senhas diferentes'),
        ]),
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
    decoration: InputDecoration(
      label: Text(
        'Senha',
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: Colors.black,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    ),
    cursorColor: Colors.black,
    validator: Validatorless.multiple([
      Validatorless.required('Senha ibrigatória'),
      Validatorless.min(8, 'Mínimo 8 caracteres'),
    ]),
    validationRules: {
      DigitValidationRule(customText: 'Um numero'),
      UppercaseValidationRule(customText: 'Letra maiúscula'),
      MinCharactersValidationRule(8, customText: '8 caracteres'),
    },
    hasStrengthIndicator: false,
    validationRuleBuilder: (rules, value) {
      return Column(
        crossAxisAlignment: .start,
        spacing: 10,
        children: [
          const SizedBox(height: 5),
          Text('A senha deve conter pelo menos: '),
          ...rules.map(
            (rule) => _passwordValidator(context, rule, value),
          ),
        ],
      );
    },
  );
}
