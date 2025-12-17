import 'package:flutter/material.dart';
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
        ? _cardCarrinho(preco, theme)
        : _cardAddress(preco, taxa ?? 0, theme);
  }
}

Widget _cardCarrinho(double preco, ThemeData theme) {
  return Card(
    elevation: 5,
    color: theme.colorScheme.secondary,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
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

Widget _cardAddress(double preco, double taxa, ThemeData theme) {
  return Card(
    elevation: 5,
    color: theme.colorScheme.secondary,
    child: Container(
      padding: EdgeInsets.all(10),
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
