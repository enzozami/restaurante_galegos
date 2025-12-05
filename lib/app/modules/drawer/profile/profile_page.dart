import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/modules/drawer/profile/profile_controller.dart';
import 'package:restaurante_galegos/app/modules/drawer/profile/widget/profile_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends GalegosState<ProfilePage, ProfileController> {
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
                        padding: const EdgeInsets.only(top: 50.0, bottom: 10),
                        child: Center(
                          child: Text(
                            'DADOS DO USUÁRIO',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            ProfileData(
                              title: 'Nome:',
                              obscure: false,
                              label: controller.name,
                              controller: controller.newNameEC,
                              isSelected: controller.isSelected,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.isSelected == true,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GalegosButtonDefault(
                                  label: 'Atualizar',
                                  onPressed: () {
                                    if (controller.validateForm()) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.black,
                                            titlePadding: const EdgeInsets.only(
                                              top: 20,
                                              left: 24,
                                              right: 24,
                                              bottom: 0,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 10,
                                            ),
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
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Alerta',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: Text(
                                              'Tem certeza que deseja alterar os dados?',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                    controller.isSelected = false;
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
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    await controller.updateName();
                                                    controller.isSelected = false;
                                                    Get.snackbar(
                                                      'Sucesso',
                                                      'Dados atualizados com sucesso',
                                                      duration: 3.seconds,
                                                      backgroundColor:
                                                          GalegosUiDefaut.colorScheme.primary,
                                                    );

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
                                              ),
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
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
