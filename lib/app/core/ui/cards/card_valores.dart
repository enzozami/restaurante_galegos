import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';

class CardValores extends StatelessWidget {
  final double preco;
  final double? taxa;
  final bool carrinho;

  const CardValores({
    super.key,
    required this.preco,
    this.taxa,
    required this.carrinho,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return carrinho
        ? _cardCarrinho(context, preco, theme)
        : _cardAddress(context, preco, taxa ?? 0, theme);
  }
}

Widget _cardCarrinho(BuildContext context, double preco, ThemeData theme) {
  return Card(
    elevation: 5,
    margin: EdgeInsets.zero,
    color: theme.colorScheme.secondary,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          Text(
            'Total: ${FormatterHelper.formatCurrency(preco)}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    ),
  );
}

Widget _cardAddress(BuildContext context, double preco, double taxa, ThemeData theme) {
  return Card(
    elevation: 5,
    color: theme.colorScheme.secondary,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: context.widthTransformer(reducedBy: 10),
      child: Column(
        children: [
          Text(
            'Total dos itens: ${FormatterHelper.formatCurrency(preco)}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),

          Text(
            'Taxa de entrega: ${FormatterHelper.formatCurrency(taxa)}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            'Total a pagar: ${FormatterHelper.formatCurrency(preco + taxa)}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    ),
  );
}
