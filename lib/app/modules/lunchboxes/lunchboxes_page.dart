import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/filter_tag.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/section_header.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/alimentos_widget.dart';
import 'package:validatorless/validatorless.dart';

import './lunchboxes_controller.dart';

class LunchboxesPage extends StatefulWidget {
  const LunchboxesPage({super.key});

  @override
  State<LunchboxesPage> createState() => _LunchboxesPageState();
}

class _LunchboxesPageState extends GalegosState<LunchboxesPage, LunchboxesController> {
  // --- FORMULÁRIO ---
  final nomeMarmitaEC = TextEditingController();
  final descricaoEC = TextEditingController();
  final precoMiniEC = TextEditingController();
  final precoMediaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nomeMarmitaEC.dispose();
    descricaoEC.dispose();
    precoMediaEC.dispose();
    precoMiniEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: controller.admin
          ? _FloatingActionAdmin(
              formKey: formKey,
              controller: controller,
              nomeMarmitaEC: nomeMarmitaEC,
              descricaoEC: descricaoEC,
              precoMiniEC: precoMiniEC,
              precoMediaEC: precoMediaEC,
            )
          : null,

      body: RefreshIndicator.noSpinner(
        onRefresh: controller.refreshLunchboxes,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 15, left: 10, right: 10),
                      child: Visibility(
                        visible: controller.admin != true,
                        replacement: Obx(() {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: controller.times
                                  .expand((e) => e.days)
                                  .map(
                                    (d) => FilterTag(
                                      isSelected: controller.daysSelected.value == d,
                                      onPressed: () {
                                        controller.filterByDay(d);
                                      },
                                      days: d,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        }),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Marmitas de Hoje',
                                  textAlign: TextAlign.center,
                                  style: GalegosUiDefaut.theme.textTheme.titleLarge,
                                ),
                                Text(
                                  controller.dayNow,
                                  style: GalegosUiDefaut.theme.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    AlimentosWidget(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FloatingActionAdmin extends StatelessWidget {
  const _FloatingActionAdmin({
    required this.formKey,
    required this.controller,
    required this.nomeMarmitaEC,
    required this.descricaoEC,
    required this.precoMiniEC,
    required this.precoMediaEC,
  });

  final GlobalKey<FormState> formKey;
  final LunchboxesController controller;
  final TextEditingController nomeMarmitaEC;
  final TextEditingController descricaoEC;
  final TextEditingController precoMiniEC;
  final TextEditingController precoMediaEC;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.directional(1, 1),
      child: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Form(
                key: formKey,
                child: AlertDialog(
                  backgroundColor: GalegosUiDefaut.colors['fundo'],
                  titlePadding: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  actionsPadding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
                  icon: Align(
                    alignment: .bottomRight,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close),
                      color: GalegosUiDefaut.colorScheme.tertiary,
                    ),
                  ),
                  title: Text(
                    'Adiciona Marmita',
                    overflow: .ellipsis,
                    textAlign: .center,
                    style: GalegosUiDefaut.theme.textTheme.titleMedium,
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      spacing: 20,
                      children: [
                        SectionHeader(
                          items: controller.times
                              .expand((e) => e.days)
                              .map((day) => MultiSelectCard(value: day, label: day[0]))
                              .toList(),
                          onChanged: (allSelectedItems, selectedItem) {
                            controller.addDays.value = allSelectedItems.map((e) => e).toList();
                          },
                        ),
                        GalegosTextFormField(
                          colorText: GalegosUiDefaut.colorScheme.tertiary,
                          colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                          floatingLabelBehavior: .auto,
                          enabled: true,
                          label: 'Nome da Marmita',
                          validator: Validatorless.required('Nome inválido'),
                          controller: nomeMarmitaEC,
                        ),
                        GalegosTextFormField(
                          colorText: GalegosUiDefaut.colorScheme.tertiary,
                          colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                          floatingLabelBehavior: .auto,
                          enabled: true,
                          label: 'Descrição',
                          controller: descricaoEC,
                        ),
                        GalegosTextFormField(
                          colorText: GalegosUiDefaut.colorScheme.tertiary,
                          colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                          floatingLabelBehavior: .auto,
                          enabled: true,
                          inputType: .number,
                          prefixText: 'R\$ ',
                          validator: Validatorless.multiple([
                            Validatorless.required('Nome inválido'),
                          ]),
                          label: 'Preço Marmita Mini',
                          controller: precoMiniEC,
                        ),
                        GalegosTextFormField(
                          colorText: GalegosUiDefaut.colorScheme.tertiary,
                          colorBorder: GalegosUiDefaut.colorScheme.tertiary,
                          floatingLabelBehavior: .auto,
                          enabled: true,
                          inputType: .number,
                          prefixText: 'R\$ ',
                          validator: Validatorless.multiple([
                            Validatorless.required('Nome inválido'),
                          ]),
                          label: 'Preço Marmita Média',
                          controller: precoMediaEC,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GalegosUiDefaut.colorScheme.primary,
                        foregroundColor: GalegosUiDefaut.colorScheme.onPrimary,
                      ),
                      onPressed: () async {
                        final formValid = formKey.currentState?.validate() ?? false;
                        if (formValid) {
                          final name = nomeMarmitaEC.text;
                          final priceMini = double.parse(precoMiniEC.text);
                          final priceMedia = double.parse(precoMediaEC.text);
                          final description = descricaoEC.text;

                          controller.cadastrar(name, description, priceMini, priceMedia);
                        }
                        nomeMarmitaEC.clear();
                        descricaoEC.clear();
                        precoMiniEC.clear();
                        precoMediaEC.clear();
                        controller.refreshLunchboxes();
                        Get.back();
                      },
                      child: Text('Cadastrar'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        icon: Icon(Icons.add),
        backgroundColor: GalegosUiDefaut.theme.floatingActionButtonTheme.backgroundColor,
        foregroundColor: GalegosUiDefaut.theme.floatingActionButtonTheme.foregroundColor,
        label: Text('Adicionar'),
      ),
    );
  }
}
