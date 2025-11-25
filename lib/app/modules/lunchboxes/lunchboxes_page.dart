import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/filter_tag.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/alimentos_widget.dart';
import 'package:validatorless/validatorless.dart';

// import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_header.dart';
import './lunchboxes_controller.dart';

class LunchboxesPage extends StatefulWidget {
  const LunchboxesPage({super.key});

  @override
  State<LunchboxesPage> createState() => _LunchboxesPageState();
}

class _LunchboxesPageState
    extends GalegosState<LunchboxesPage, LunchboxesController> {
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
          ? Align(
              alignment: AlignmentGeometry.directional(1, 1),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Form(
                        key: formKey,
                        child: AlertDialog(
                          backgroundColor:
                              GalegosUiDefaut.colorScheme.onPrimary,
                          titlePadding: const EdgeInsets.only(
                            top: 15,
                            left: 24,
                            right: 24,
                            bottom: 0,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          actionsPadding: const EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                            bottom: 15,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Adiciona Marmita',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: GalegosUiDefaut.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: GalegosUiDefaut.colorScheme.secondary,
                                ),
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              spacing: 20,
                              children: [
                                MultiSelectContainer(
                                  items: controller.times
                                      .expand((e) => e.days)
                                      .map(
                                        (day) => MultiSelectCard(
                                          value: day,
                                          label: day[0],
                                        ),
                                      )
                                      .toList(),
                                  onChange: (allSelectedItems, selectedItem) {
                                    controller.addDays.value = allSelectedItems
                                        .map((e) => e)
                                        .toList();
                                  },
                                  itemsDecoration: MultiSelectDecorations(
                                    selectedDecoration: BoxDecoration(
                                      color:
                                          GalegosUiDefaut.colorScheme.primary,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          GalegosUiDefaut.colorScheme.secondary,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                GalegosTextFormField(
                                  colorText:
                                      GalegosUiDefaut.colorScheme.primary,
                                  colorBorder:
                                      GalegosUiDefaut.colorScheme.secondary,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  enabled: true,
                                  label: 'Nome da Marmita',
                                  validator: Validatorless.required(
                                    'Nome inválido',
                                  ),
                                  controller: nomeMarmitaEC,
                                ),
                                GalegosTextFormField(
                                  colorText:
                                      GalegosUiDefaut.colorScheme.primary,
                                  colorBorder:
                                      GalegosUiDefaut.colorScheme.secondary,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  enabled: true,
                                  label: 'Descrição',
                                  controller: descricaoEC,
                                ),
                                GalegosTextFormField(
                                  colorText:
                                      GalegosUiDefaut.colorScheme.primary,
                                  colorBorder:
                                      GalegosUiDefaut.colorScheme.secondary,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  enabled: true,
                                  inputType: TextInputType.number,
                                  prefixText: 'R\$ ',
                                  validator: Validatorless.multiple([
                                    Validatorless.required('Nome inválido'),
                                  ]),
                                  label: 'Preço Marmita Mini',
                                  controller: precoMiniEC,
                                ),
                                GalegosTextFormField(
                                  colorText:
                                      GalegosUiDefaut.colorScheme.primary,
                                  colorBorder:
                                      GalegosUiDefaut.colorScheme.secondary,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  enabled: true,
                                  inputType: TextInputType.number,
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
                                backgroundColor:
                                    GalegosUiDefaut.colorScheme.primary,
                                foregroundColor:
                                    GalegosUiDefaut.colorScheme.onPrimary,
                              ),
                              onPressed: () async {
                                final formValid =
                                    formKey.currentState?.validate() ?? false;
                                if (formValid) {
                                  final name = nomeMarmitaEC.text;
                                  final priceMini = double.parse(
                                    precoMiniEC.text,
                                  );
                                  final priceMedia = double.parse(
                                    precoMediaEC.text,
                                  );
                                  final description = descricaoEC.text;

                                  controller.cadastrar(
                                    name,
                                    description,
                                    priceMini,
                                    priceMedia,
                                  );
                                  Get.back();
                                  Get.snackbar(
                                    'Marmita - ${nomeMarmitaEC.text}',
                                    'Marmita adicionada com sucesso',
                                  );
                                }
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
                backgroundColor: GalegosUiDefaut
                    .theme
                    .floatingActionButtonTheme
                    .backgroundColor,
                foregroundColor: GalegosUiDefaut
                    .theme
                    .floatingActionButtonTheme
                    .foregroundColor,
                label: Text('Adicionar'),
              ),
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
                      padding: const EdgeInsets.only(top: 30.0, bottom: 15),
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
                                      isSelected:
                                          controller.daysSelected.value == d,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Marmitas de Hoje',
                                  textAlign: TextAlign.center,
                                  style: GalegosUiDefaut
                                      .theme
                                      .textTheme
                                      .titleLarge,
                                ),
                                Text(
                                  controller.dayNow,
                                  style: GalegosUiDefaut
                                      .theme
                                      .textTheme
                                      .titleSmall,
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
