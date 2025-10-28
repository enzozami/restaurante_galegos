import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class GalegosDrawer extends StatelessWidget {
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
          const SizedBox(
            height: 50,
          ),
          ButtonDrawer(
            title: 'Perfil',
            onTap: () {
              Get.toNamed('/profile');
            },
          ),
          Divider(),
          ButtonDrawer(
            title: 'Horário de funcionamento',
            onTap: () {
              Get.toNamed('/time');
            },
          ),
          Divider(),
          ButtonDrawer(
            title: 'Sobre nós',
            onTap: () {
              Get.toNamed('/about_us');
            },
          ),
          Divider(),
          ButtonDrawer(
            title: 'Sair',
            onTap: AuthService().logout,
          ),
          Divider(),
        ],
      ),
    );
  }
}

class ButtonDrawer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ButtonDrawer({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 100,
        ),
        width: context.width,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              // textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
