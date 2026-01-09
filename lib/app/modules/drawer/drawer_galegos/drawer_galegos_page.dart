import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/dialogs/alert_dialog_confirm_exit.dart';
import './drawer_galegos_controller.dart';

class DrawerGalegosPage extends GetView<DrawerGalegosController> {
  const DrawerGalegosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.drawerTheme.backgroundColor,
      width: context.widthTransformer(reducedBy: 20),
      elevation: 1,
      child: Column(
        mainAxisAlignment: .start,
        children: [
          SizedBox(
            height: context.heightTransformer(reducedBy: 70),
            child: Obx(() {
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary,
                ),
                accountName: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Olá, ${controller.nome.value}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    controller.isAdmin.value ? 'Administrador' : controller.email.value,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
                  ),
                ),
              );
            }),
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
          Spacer(),
          ButtonDrawer(
            title: 'Sair',
            icon: Icons.logout,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogConfirmExit(
                    onPressed: () => controller.logout(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ButtonDrawer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  const ButtonDrawer({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isPressed = false.obs;
    return Obx(() {
      final scale = isPressed.value ? 0.97 : 1.0;
      return GestureDetector(
        onTap: onTap,
        onTapUp: (_) => isPressed.value = false,
        onTapCancel: () => isPressed.value = false,
        onTapDown: (_) => isPressed.value = true,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 80),
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: (icon != null)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      child: buttonDrawer(context, title, icon!, theme),
                    )
                  : SizedBox(
                      width: context.widthTransformer(reducedBy: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }
}

Widget buttonDrawer(
  BuildContext context,
  String title,
  IconData icon,
  ThemeData theme,
) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFFFC4C4),
      borderRadius: BorderRadius.circular(5),
    ),
    width: context.widthTransformer(reducedBy: 10),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        spacing: 10,
        mainAxisAlignment: .center,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.error,
          ),
          Text(
            title,
            style: theme.textTheme.titleSmall!.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    ),
  );
}
