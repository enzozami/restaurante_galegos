import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/card_model.dart';

class FinishedController extends GetxController {
  final CardModel orderFinished = Get.arguments;

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Pedido Finalizado!',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                columnWidths: const <int, pw.TableColumnWidth>{
                  0: pw.FixedColumnWidth(60),
                  1: pw.FlexColumnWidth(),
                  2: pw.FixedColumnWidth(90),
                  3: pw.FixedColumnWidth(90),
                  4: pw.FixedColumnWidth(90),
                },
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'ID Item',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Item',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Quantidade',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Preço Unit.',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'R\$ X Quantidade',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ...orderFinished.items.map(
                (item) {
                  // ID do item
                  final id = item.food != null ? item.food!.id : item.product!.id;
                  // nome do item
                  final name = item.food != null ? item.food!.name : item.product!.name;
                  // preço unitário do item
                  final unitPrice = item.food != null ? item.selectedPrice : item.product!.price;
                  final price = FormatterHelper.formatCurrency(unitPrice!);
                  final total = FormatterHelper.formatCurrency(unitPrice * item.quantity);

                  return pw.Table(
                    columnWidths: const <int, pw.TableColumnWidth>{
                      0: pw.FixedColumnWidth(60),
                      1: pw.FlexColumnWidth(),
                      2: pw.FixedColumnWidth(90),
                      3: pw.FixedColumnWidth(90),
                      4: pw.FixedColumnWidth(90),
                    },
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '$id',
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              name,
                              textAlign: pw.TextAlign.left,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${item.quantity}',
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              price,
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              total,
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/pedido_${orderFinished.id}.pdf");
    try {
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);
      await Printing.sharePdf(bytes: bytes, filename: 'pedido_${orderFinished.id}.pdf');
    } catch (e, s) {
      log('Erro ao gerar PDF: $e', stackTrace: s);
    }
  }
}
