import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:restaurante_galegos/app/core/masks/galegos_mask.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/modules/drawer/profile/profile_controller.dart';
import 'package:validatorless/validatorless.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: GalegosAppBar(context: context),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            spacing: 15,
            crossAxisAlignment: .start,
            children: [
              SafeArea(child: Container()),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15),
                child: Text(
                  'Perfil',
                  style: theme.textTheme.headlineLarge,
                ),
              ),

              controller.edit.value
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.zero,
                        width: context.widthTransformer(reducedBy: 10),
                        child: GalegosTextFormField(
                          floatingLabelBehavior: .auto,
                          prefix: true,
                          suffix: false,
                          prefixIcon: Icons.person,
                          controller: controller.newNameEC,
                          label: 'Nome Completo',
                          colorBorder: const Color(0xFFBE8462),
                          validator: Validatorless.min(3, 'Mínimo 3 caracteres'),
                          filled: true,
                          fillColor: theme.cardTheme.color,
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        padding: EdgeInsets.zero,
                        width: context.widthTransformer(reducedBy: 10),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                            ),
                            title: Text(
                              controller.nameClient.value,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
              controller.edit.value
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.zero,
                        width: context.widthTransformer(reducedBy: 10),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: .start,
                              spacing: 25,
                              children: [
                                Text(
                                  'Informações para Contato',
                                  style: theme.textTheme.titleSmall,
                                ),
                                _containerForEditContactInformations(
                                  context: context,
                                  icon: Icons.email_outlined,
                                  title: 'E-mail',
                                  textInputType: .emailAddress,
                                  validator: Validatorless.email('E-mail inválido'),
                                  controller: controller.newEmailEC,
                                ),
                                _containerForEditContactInformations(
                                  context: context,
                                  title: 'Telefone',
                                  icon: Icons.phone,
                                  textInputType: .phone,
                                  validator: Validatorless.phone('Número de telefone inválido'),
                                  mask: GalegosMask(),
                                  controller: controller.newPhoneEC,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        padding: EdgeInsets.zero,
                        width: context.widthTransformer(reducedBy: 10),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: .start,
                              spacing: 25,
                              children: [
                                Text(
                                  'Informações para Contato',
                                  style: theme.textTheme.titleSmall,
                                ),
                                _containerForContactInformation(
                                  context: context,
                                  icon: Icons.email_outlined,
                                  title: 'E-mail',
                                  value: controller.emailClient.value,
                                ),
                                _containerForContactInformation(
                                  context: context,
                                  icon: Icons.phone,
                                  title: 'Telefone',
                                  value: controller.phoneClient.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

              // Center(
              //   child: Container(
              //     padding: EdgeInsets.zero,
              //     width: context.widthTransformer(reducedBy: 10),
              //     child: Card(
              //       margin: EdgeInsets.zero,
              //       child: Padding(
              //         padding: const EdgeInsets.all(20),
              //         child: Column(
              //           crossAxisAlignment: .start,
              //           spacing: 25,
              //           children: [
              //             Text(
              //               'Preferências',
              //               style: theme.textTheme.titleSmall,
              //             ),
              //             _containerForPreferences(
              //               context: context,
              //               icon: Icons.notifications_active_outlined,
              //               title: 'Notificações',
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              controller.edit.value
                  ? Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        Center(
                          child: GalegosButtonDefault(
                            width: context.widthTransformer(reducedBy: 60),
                            style: theme.elevatedButtonTheme.style?.copyWith(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                theme.colorScheme.error,
                              ),
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                theme.colorScheme.onError,
                              ),
                            ),
                            label: 'Cancelar',
                            onPressed: () => controller.pressForEditOrCancel(),
                          ),
                        ),
                        Center(
                          child: GalegosButtonDefault(
                            width: context.widthTransformer(reducedBy: 60),
                            label: 'Salvar',
                            onPressed: () => controller.updateData(),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: SizedBox(
                        width: context.widthTransformer(reducedBy: 10),
                        child: GalegosButtonDefault(
                          label: 'Editar',
                          width: double.infinity,
                          onPressed: () => controller.pressForEditOrCancel(),
                        ),
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}

Widget _containerForContactInformation({
  required BuildContext context,
  required String title,
  required IconData icon,
  required String value,
}) {
  return Row(
    spacing: 10,
    children: [
      Icon(
        icon,
        color: AppColors.title,
        size: 50,
      ),
      Column(
        spacing: 4,
        crossAxisAlignment: .start,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    ],
  );
}

//TODO - Widget retirado pois o app ainda nao tem nada sobre notificações - quando tiver será implementado
Widget _containerForPreferences({
  required BuildContext context,
  required IconData icon,
  required String title,
}) {
  final ThemeData theme = Theme.of(context);
  return Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Row(
        spacing: 15,
        children: [
          Icon(
            icon,
            size: 32,
            color: theme.colorScheme.primary,
          ),
          Text(title),
        ],
      ),
      //! TODO - ARRUMAR SWITCH (NÃO ESTÁ FUNCIONANDO)
      Switch.adaptive(value: false, onChanged: (_) {}),
    ],
  );
}

Widget _containerForEditContactInformations({
  required BuildContext context,
  required IconData icon,
  required String title,
  required TextInputType textInputType,
  required TextEditingController controller,
  required FormFieldValidator<String> validator,
  MaskTextInputFormatter? mask,
}) {
  return Row(
    spacing: 10,
    children: [
      Icon(
        icon,
        color: AppColors.title,
        size: 50,
      ),
      SizedBox(
        width: context.widthTransformer(reducedBy: 35),
        child: GalegosTextFormField(
          floatingLabelBehavior: .auto,
          prefix: false,
          suffix: false,
          label: title,
          controller: controller,
          inputType: textInputType,
          colorBorder: const Color(0xFFBE8462),
          mask: mask,
          validator: Validatorless.multiple([validator]),
        ),
      ),
    ],
  );
}
