//PARTE DO ADMIN

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_app_bar.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import 'package:restaurante_galegos/app/models/card_model.dart';
import 'package:restaurante_galegos/app/modules/order/finished/finished_controller.dart';
import 'package:restaurante_galegos/app/modules/order/finished/widgets/galegos_table.dart';

class FinishedPage extends StatelessWidget {
  final CardModel orderFinished = Get.arguments;
  final FinishedController controller = Get.put(FinishedController());
  FinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GalegosAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Pedido Finalizado!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(60),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(60),
                    3: FixedColumnWidth(90),
                    4: FixedColumnWidth(90),
                  },
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'ID Item',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Item',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Quantidade',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Preço Unitário',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'R\$ X Quantidade',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ...orderFinished.items.map(
                (item) {
                  // Get item name
                  final foodName = item.food?.name ?? '';
                  final productName = item.product?.name ?? '';
                  final itemName = foodName.isNotEmpty ? foodName : productName;

                  // Get item ID
                  final idFood = item.food?.id;
                  final idProduct = item.product?.id;
                  final idItem = idFood ?? idProduct ?? 0;

                  // Get item price
                  final foodPrice = item.selectedPrice ?? 0.0;
                  log('FOODPRICE: ${item.selectedPrice}');
                  final price = FormatterHelper.formatCurrency(item.product?.price ?? foodPrice);
                  final priceQtdd = FormatterHelper.formatCurrency(
                      item.product?.price ?? foodPrice * item.quantity);

                  // Table
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GalegosTable(
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '$idItem',
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                itemName,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '${item.quantity}',
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(price,
                                  textAlign: TextAlign.right, overflow: TextOverflow.ellipsis),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(priceQtdd,
                                  textAlign: TextAlign.right, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Valor Final: ${FormatterHelper.formatCurrency(orderFinished.amountToPay)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GalegosButtonDefault(
                onPressed: () {
                  controller.generatePDF();
                },
                label: 'Gerar PDF',
              ),
              GalegosButtonDefault(
                onPressed: () {
                  Get.offAllNamed('/home');
                },
                label: 'Voltar ao Início',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
