import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/widgets/profile_data.dart';
import 'package:validatorless/validatorless.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends GalegosState<ProfilePage, GalegosDrawerController> {
  final _formKey = GlobalKey<FormState>();
  final _newNameEC = TextEditingController();
  final _newPasswordEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _newNameEC.dispose();
    _newPasswordEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(
        icon: Obx(() {
          return IconButton(
            onPressed: controller.isSelect,
            icon: controller.isSelected ? Icon(Icons.close) : Icon(Icons.edit),
          );
        }),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Obx(() {
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 50.0,
                          bottom: 10,
                        ),
                        child: Center(
                          child: Text(
                            'DADOS DO USUÁRIO',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ProfileData(
                              title: 'Nome:',
                              label: controller.name.string,
                              controller: _newNameEC,
                              isSelected: controller.isSelected,
                              validator: Validatorless.required('Campo obrigatório'),
                            ),
                            ProfileData(
                              title: 'CPF/CNPJ:',
                              label: controller.valueCpfOrCnpj.value,
                              isSelected: false,
                            ),
                            ProfileData(
                              title: 'Senha:',
                              label: controller.password.value,
                              controller: _newPasswordEC,
                              isSelected: controller.isSelected,
                              obscure: controller.isObscure,
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                                Validatorless.min(6, 'Mínimo 6 caracteres')
                              ]),
                            ),
                            ProfileData(
                              title: 'Confirmar Senha:',
                              label: controller.password.value,
                              isSelected: controller.isSelected,
                              obscure: controller.isObscure,
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                                Validatorless.compare(_newPasswordEC, 'Senhas precisam ser iguais')
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.isSelected == true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GalegosButtonDefault(
                              label: 'Atualizar',
                              onPressed: () {},
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
