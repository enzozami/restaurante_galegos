import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/modules/drawer/profile/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: GalegosAppBar(context: context),
      extendBodyBehindAppBar: true,
      body: Column(
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

          Center(
            child: SizedBox(
              width: context.widthTransformer(reducedBy: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                    ),
                    title: Text(
                      '${controller.nameClient}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: context.widthTransformer(reducedBy: 10),
              child: Card(
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
                        value: 'enzo@enzo.com',
                      ),
                      _containerForContactInformation(
                        context: context,
                        icon: Icons.phone,
                        title: 'Telefone',
                        value: '(99) 99999-9999',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: SizedBox(
              width: context.widthTransformer(reducedBy: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 25,
                    children: [
                      Text(
                        'Preferências',
                        style: theme.textTheme.titleSmall,
                      ),
                      _containerForPreferences(
                        context: context,
                        icon: Icons.notifications_active_outlined,
                        title: 'Notificações',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //! TODO - Arrumar botão de editar
          Center(
            child: GalegosButtonDefault(
              label: 'Editar',
              width: context.widthTransformer(reducedBy: 10),
              onPressed: () {},
            ),
          ),
        ],
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

Widget _containerForPreferences({
  required BuildContext context,
  required IconData icon,
  required String title,
}) {
  return Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Row(
        spacing: 15,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          Text(title),
        ],
      ),
      //! TODO - ARRUMAR SWITCH (NÃO ESTÁ FUNCIONANDO)
      Switch.adaptive(value: false, onChanged: (_) {}),
    ],
  );
}
