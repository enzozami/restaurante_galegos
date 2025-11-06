import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cnpj.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_check_box.dart';
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
  final _usuarioEC = TextEditingController();
  final _passwordEC = TextEditingController();

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
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                controller: _nameEC,
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
                                  GalegosCheckBox(
                                    isChecked: controller.isChecked,
                                    onChanged: (value) => controller.onSelected(value ?? false),
                                  ),
                                ],
                              ),
                              GalegosTextFormField(
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                controller: _usuarioEC,
                                inputType: TextInputType.number,
                                mask: (controller.isCpf == true) ? MaskCpf() : MaskCnpj(),
                                label: (controller.isChecked) ? 'CNPJ' : 'CPF',
                                validator: Validatorless.multiple([
                                  Validatorless.required('Campo obrigatório'),
                                  (controller.isCpf == true)
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
                                label: 'Senha (Mínimo 6 caracteres)',
                                validator: Validatorless.multiple([
                                  Validatorless.required('Senha obrigatória'),
                                  Validatorless.min(6, 'Senha obrigatória'),
                                ]),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
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
                              const SizedBox(
                                height: 25,
                              ),
                              GalegosButtonDefault(
                                label: 'Cadastrar',
                                onPressed: () {
                                  final formValid = _formKey.currentState?.validate() ?? false;
                                  if (formValid) {
                                    controller.register(
                                      name: _nameEC.text,
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
