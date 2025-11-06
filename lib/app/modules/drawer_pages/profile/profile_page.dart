import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/profile/widgets/profile_data.dart';
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
                              obscure: false,
                              label: controller.name,
                              controller: _newNameEC,
                              isSelected: controller.isSelected,
                            ),
                            ProfileData(
                              title: 'CPF/CNPJ:',
                              label: controller.valueCpfOrCnpj.value,
                              isSelected: false,
                              obscure: false,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.isSelected == true,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Deseja atualizar senha?',
                                  style: TextStyle(fontSize: 15),
                                ),
                                TextButton(
                                  onPressed: () => controller.atualizarSenha(),
                                  child: Text(
                                    'Clique aqui',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: GalegosUiDefaut.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: controller.senha.value,
                              child: Obx(() {
                                return ProfileData(
                                  title: 'Senha:',
                                  label: '',
                                  controller: _newPasswordEC,
                                  isSelected: controller.isSelected,
                                  obscure: controller.isPasswordSee.value,
                                  validator: Validatorless.min(6, 'Mínimo 6 caracteres'),
                                  icon: IconButton(
                                    onPressed: () {
                                      controller.seePassword();
                                    },
                                    icon: (controller.isPasswordSee.value)
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  ),
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GalegosButtonDefault(
                                    label: 'Atualizar',
                                    onPressed: () {
                                      final formValid = _formKey.currentState?.validate() ?? false;
                                      if (formValid) {
                                        final name = _newNameEC.text;
                                        final password = _newPasswordEC.text;

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.black,
                                              titlePadding: const EdgeInsets.only(
                                                  top: 20, left: 24, right: 24, bottom: 0),
                                              contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 24, vertical: 10),
                                              actionsPadding: const EdgeInsets.all(20),
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.help_outline_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Alerta',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              content: Text(
                                                'Tem certeza que deseja alterar os dados?',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              actions: [
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          GalegosUiDefaut.colorScheme.primary,
                                                      minimumSize: Size(double.infinity, 50),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)),
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      controller.isSelected = false;
                                                      _newPasswordEC.text = '';
                                                    },
                                                    child: Text(
                                                      'Cancelar',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          GalegosUiDefaut.colorScheme.primary,
                                                      minimumSize: Size(double.infinity, 50),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)),
                                                    ),
                                                    onPressed: () {
                                                      if (password == '') {
                                                        controller.updateUser(name, password);
                                                        controller.isSelected = false;
                                                        Get.snackbar(
                                                          'Sucesso',
                                                          'Dados atualizados com sucesso',
                                                          duration: 3.seconds,
                                                          backgroundColor:
                                                              GalegosUiDefaut.colorScheme.primary,
                                                        );
                                                      } else if (password.length >= 6) {
                                                        controller.updateUser(name, password);
                                                        controller.isSelected = false;
                                                        Get.snackbar(
                                                          'Sucesso',
                                                          'Dados atualizados com sucesso',
                                                          duration: 3.seconds,
                                                          backgroundColor:
                                                              GalegosUiDefaut.colorScheme.primary,
                                                        );
                                                      }
                                                      Get.close(0);
                                                    },
                                                    child: Text(
                                                      'Confirmar',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        Get.snackbar(
                                          'Erro',
                                          'Senha precisa ter no mínimo 6 caracteres',
                                          duration: 3.seconds,
                                          backgroundColor: GalegosUiDefaut.colorScheme.primary,
                                        );
                                      }
                                    }),
                              ),
                            ),
                          ],
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
