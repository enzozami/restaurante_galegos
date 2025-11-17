import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_state.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/alimentos_widget.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_header.dart';
import 'package:validatorless/validatorless.dart';
// import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/lunchboxes_header.dart';
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
          ? Align(
              alignment: AlignmentGeometry.directional(1, 0.80),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Form(
                        key: formKey,
                        child: AlertDialog(
                          backgroundColor: GalegosUiDefaut.colorScheme.onPrimary,
                          titlePadding:
                              const EdgeInsets.only(top: 15, left: 24, right: 24, bottom: 0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          actionsPadding:
                              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
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
                                icon:
                                    Icon(Icons.close, color: GalegosUiDefaut.colorScheme.secondary),
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              spacing: 20,
                              children: [
                                MultiSelectContainer(
                                  suffix: MultiSelectSuffix(
                                    selectedSuffix: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.check,
                                        color: GalegosUiDefaut.colorScheme.onPrimary,
                                        size: 14,
                                      ),
                                    ),
                                    disabledSuffix: const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.do_disturb_alt_sharp,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  items: controller.times
                                      .expand((e) => e.days)
                                      .map(
                                        (day) => MultiSelectCard(
                                          value: day,
                                          child: SizedBox(
                                            width: context.widthTransformer(reducedBy: 40),
                                            height: 40,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    day,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChange: (allSelectedItems, selectedItem) {
                                    controller.daysSelected.value =
                                        allSelectedItems.map((e) => e).toList();
                                  },
                                  itemsDecoration: MultiSelectDecorations(
                                    selectedDecoration: BoxDecoration(
                                      color: GalegosUiDefaut.colorScheme.primary,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    decoration: BoxDecoration(
                                      color: GalegosUiDefaut.colorScheme.secondary,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                GalegosTextFormField(
                                  colorText: GalegosUiDefaut.colorScheme.primary,
                                  colorBorder: GalegosUiDefaut.colorScheme.secondary,
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  enabled: true,
                                  label: 'Nome da Marmita',
                                  validator: Validatorless.required('Nome inválido'),
                                  controller: nomeMarmitaEC,
                                ),
                                GalegosTextFormField(
                                  colorText: GalegosUiDefaut.colorScheme.primary,
                                  colorBorder: GalegosUiDefaut.colorScheme.secondary,
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  enabled: true,
                                  label: 'Descrição',
                                  controller: descricaoEC,
                                ),
                                GalegosTextFormField(
                                  colorText: GalegosUiDefaut.colorScheme.primary,
                                  colorBorder: GalegosUiDefaut.colorScheme.secondary,
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                                  colorText: GalegosUiDefaut.colorScheme.primary,
                                  colorBorder: GalegosUiDefaut.colorScheme.secondary,
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                icon: Icon(
                  Icons.add,
                  color: GalegosUiDefaut.colorScheme.primary,
                ),
                backgroundColor: GalegosUiDefaut.theme.floatingActionButtonTheme.backgroundColor,
                label: Text(
                  'Adicionar',
                  style: TextStyle(
                    color: GalegosUiDefaut.colorScheme.primary,
                  ),
                ),
              ),
            )
          : null,
      bottomSheet: LunchboxesHeader(),
      body: RefreshIndicator.noSpinner(
        onRefresh: controller.refreshLunchboxes,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 15),
                child: Visibility(
                  visible: controller.admin != true,
                  replacement: Center(
                    child: Text(
                      'MARMITAS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  child: Text(
                    'MARMITAS DE HOJE: \n${controller.dayNow}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: (controller.sizeSelected.value == null ||
                      controller.sizeSelected.value == ''),
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.heightTransformer(reducedBy: 75),
                      ),
                      Center(
                        child: Text(
                          'Selecione um tamanho*',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // LunchboxesGroup(),
              AlimentosWidget(),
              const SizedBox(
                height: 65,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
