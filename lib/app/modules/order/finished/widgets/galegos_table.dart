import 'package:flutter/material.dart';

class GalegosTable extends StatelessWidget {
  final List<TableRow> children;

  const GalegosTable({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      // 1. Define a largura das colunas
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(60),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(60),
        3: FixedColumnWidth(90),
        4: FixedColumnWidth(90),
      },
      border: TableBorder.all(color: Colors.black),

      children: children,
    );
  }
}
