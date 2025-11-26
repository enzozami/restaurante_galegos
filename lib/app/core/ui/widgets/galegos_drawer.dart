import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services_impl.dart';

class GalegosDrawer extends GetView<AuthServices> {
  const GalegosDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: GalegosUiDefaut.theme.drawerTheme.backgroundColor,
      width: context.widthTransformer(reducedBy: 20),
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: GalegosUiDefaut.colorScheme.tertiary),
            accountName: Text(
              'Usuário: ${controller.getUserName()}',
              style: GalegosUiDefaut.textLunchboxes.titleMedium,
            ),
            accountEmail: Visibility(visible: controller.isAdmin(), child: Text('Administrador')),
          ),
          ButtonDrawer(
            title: 'Perfil',
            onTap: () {
              Get.toNamed('/profile');
            },
          ),
          ButtonDrawer(
            title: 'Horário de funcionamento',
            onTap: () {
              Get.toNamed('/time');
            },
          ),
          ButtonDrawer(
            title: 'Sobre nós',
            onTap: () {
              Get.toNamed('/about_us');
            },
          ),
          ButtonDrawer(
            title: 'Sair',
            onTap: AuthServicesImpl(authRepository: Get.find<AuthRepository>()).logout,
          ),
        ],
      ),
    );
  }
}

class ButtonDrawer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ButtonDrawer({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: GalegosUiDefaut.theme.splashColor,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              // textAlign: TextAlign.left,
              style: GalegosUiDefaut.theme.textTheme.titleSmall,
            ),
          ),
        ),
      ),
    );
  }
}
