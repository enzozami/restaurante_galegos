import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/enums/galegos_enum.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cnpj.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
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
  final _usuarioEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _isCpf = false;

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
                        key: _formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: DropdownMenu(
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(value: , label: 'CPF'),
                                  DropdownMenuEntry(value: , label: 'CNPJ'),
                                ],
                                initialSelection: _isCpf,
                                onSelected: (bool isCpf) {
                                  if (isCpf == true) {
                                    controller.onSelected(isCpf);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Obx(() {
                              final mask = (controller.type.value == GalegosEnum.cpf)
                                  ? MaskCpf()
                                  : MaskCnpj();
                              return GalegosTextFormField(
                                controller: _usuarioEC,
                                mask: mask,
                                label: (controller.) ? 'CPF' : 'CNPJ',
                                validator: Validatorless.multiple([
                                  Validatorless.required('Campo obrigatório'),
                                      ? Validatorless.cpf('CPF inválido')
                                      : Validatorless.cnpj('CNPJ inválido'),
                                ]),
                              );
                            }),
                            const SizedBox(
                              height: 25,
                            ),
                            GalegosTextFormField(
                              controller: _passwordEC,
                              obscureText: true,
                              validator: Validatorless.multiple([
                                Validatorless.required('Senha obrigatória'),
                                Validatorless.min(6, 'Senha deve ter 6 dígitos'),
                              ]),
                              label: 'Senha',
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            GalegosButtonDefault(
                              label: 'Entrar',
                              onPressed: () {
                                final formValid = _formKey.currentState?.validate() ?? false;
                                if (formValid) {
                                  controller.login();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.heightTransformer(reducedBy: 75),
                        ),
                        Text('Não possui cadastro?'),
                        TextButton(
                          onPressed: () => Get.toNamed('/auth/register'),
                          child: Text(
                            'Clique aqui',
                            style: TextStyle(
                              color: Colors.amber,
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
