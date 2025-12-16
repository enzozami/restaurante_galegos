import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/dialogs/alert_for_add_to_cart.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/filter_tag.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/text_shimmer.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/alimentos_widget.dart';

import './lunchboxes_controller.dart';

class LunchboxesPage extends GetView<LunchboxesController> {
  const LunchboxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: controller.admin
          ? _FloatingActionAdmin(
              controller: controller,
            )
          : null,

      body: RefreshIndicator(
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
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        bottom: 15,
                        left: 10,
                        right: 10,
                      ),
                      child: Obx(() {
                        return Visibility(
                          visible: controller.admin != true,
                          replacement: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: controller.times
                                  .expand((e) => e.days)
                                  .map(
                                    (d) => FilterTag(
                                      isSelected:
                                          controller.daysSelected.value == d,
                                      onPressed: () {
                                        controller.filtrarPorDia(d);
                                      },
                                      days: d,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40.0,
                              ),
                              child: controller.loading.value
                                  ? Column(
                                      children: List.generate(
                                        1,
                                        (_) =>
                                            TextShimmer(width: 300, lines: 2),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Marmitas de Hoje',
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleLarge,
                                        ),
                                        Text(
                                          controller.dayNow,
                                          style: theme.textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      }),
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
    required this.controller,
  });

  final LunchboxesController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Align(
      alignment: AlignmentGeometry.directional(1, 1),
      child: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Form(
                key: controller.formKey,
                child: AlertForAddToCart(
                  isProduct: false,
                ),
              );
            },
          );
        },
        icon: Icon(Icons.add),
        backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
        foregroundColor: theme.floatingActionButtonTheme.foregroundColor,
        label: Text('Adicionar'),
      ),
    );
  }
}
