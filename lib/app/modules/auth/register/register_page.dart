import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
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
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                controller: _nameEC,
                                label: 'Nome completo',
                                validator: Validatorless.multiple([
                                  Validatorless.required('Campo obrigatório'),
                                ]),
                              ),
                              const SizedBox(height: 15),
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                controller: _emailEC,
                                label: 'E-mail',
                                validator: Validatorless.multiple([
                                  Validatorless.required('Senha obrigatória'),
                                  Validatorless.email('E-mail inválido'),
                                ]),
                              ),

                              const SizedBox(height: 15),
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
                                label: 'Senha',
                                validator: Validatorless.multiple([
                                  Validatorless.required('Senha obrigatória'),
                                  Validatorless.min(8, 'Senha obrigatória'),
                                ]),
                              ),
                              Column(
                                children: controller.regras.map((regra) => Text(regra)).toList(),
                              ),
                              const SizedBox(height: 15),
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                obscureText: controller.isSelectedConfirmaSenha.value,
                                icon: IconButton(
                                  onPressed: () {
                                    controller.seeConfirmaPassword();
                                  },
                                  icon: controller.isSelectedConfirmaSenha.value
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                ),
                                label: 'Confirma senha',
                                validator: Validatorless.multiple([
                                  Validatorless.required('Confirma senha obrigatória'),
                                  Validatorless.compare(_passwordEC, 'Senhas diferentes'),
                                ]),
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
