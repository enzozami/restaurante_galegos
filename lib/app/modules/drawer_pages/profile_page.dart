import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/widgets/profile_data.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text('DADOS DO USUÁRIO'),
                    ),
                    Obx(() {
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ProfileData(
                              title: 'Nome:',
                              label: controller.name.string,
                              controller: _newNameEC,
                              isSelected: controller.isSelected,
                              onPressed: controller.isSelect,
                            ),
                            ProfileData(
                              title: 'Senha:',
                              label: '' ?? controller.password.string,
                              controller: _newPasswordEC,
                              isSelected: controller.isSelected,
                              onPressed: controller.isSelect,
                              obscure: controller.isObscure,
                            ),
                          ],
                        ),
                      );
                    }),
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
