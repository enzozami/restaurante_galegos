import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';

class AlertDialogHistory extends StatelessWidget {
  final String pedidoLabel;
  final String carrinhoName;
  final String valor;
  final String taxa;
  final String total;
  final String nomeCliente;
  final String rua;
  final String numeroResidencia;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;
  final String horarioInicio;
  final String horarioSairEntrega;
  final String horarioEntregue;
  final String data;
  final VoidCallback onPressed;
  final String statusPedido;
  final bool isAdmin;
  final String? titleButton;
  final String pagamento;
  final double? troco;

  const AlertDialogHistory({
    super.key,
    required this.pedidoLabel,
    required this.carrinhoName,
    required this.valor,
    required this.taxa,
    required this.total,
    required this.nomeCliente,
    required this.rua,
    required this.numeroResidencia,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.horarioInicio,
    required this.horarioSairEntrega,
    required this.horarioEntregue,
    required this.data,
    required this.onPressed,
    required this.statusPedido,
    required this.isAdmin,
    this.titleButton,
    required this.pagamento,
    this.troco,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Text(text, style: theme.textTheme.titleSmall),
    );

    Widget infoLine(String label, String value, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Text(
        '$label$value',
        style: bold
            ? TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )
            : theme.textTheme.bodyLarge,
      ),
    );
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      titlePadding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 0,
      ),
      contentPadding: const EdgeInsets.only(
        top: 15,
        left: 10,
        right: 15,
        bottom: 10,
      ),
      actionsPadding: const EdgeInsets.only(
        top: 20,
        left: 0,
        right: 20,
        bottom: 20,
      ),
      title: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .start,
        children: [
          Text(
            statusPedido[0].toUpperCase() + statusPedido.substring(1),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: context.width),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 10,
                ),
                child: sectionTitle('Dados'),
              ),
              infoLine('Nome: ', nomeCliente),
              Divider(color: theme.colorScheme.secondary),
              sectionTitle('Descrição'),
              infoLine('', carrinhoName),
              Divider(color: theme.colorScheme.secondary),
              sectionTitle('Detalhes'),
              infoLine('Data: ', data),
              infoLine('Horário do pedido: ', horarioInicio),
              Visibility(
                visible: isAdmin,
                child: infoLine('Horário entrega: ', horarioSairEntrega),
              ),
              infoLine('Horário entregue: ', horarioEntregue),
              Divider(color: theme.colorScheme.secondary),
              sectionTitle('Endereço:'),
              infoLine('Rua: ', rua),
              infoLine('Número: ', numeroResidencia),
              infoLine('Bairro: ', bairro),
              infoLine('Cidade: ', cidade),
              infoLine('Estado: ', estado),
              infoLine('CEP: ', cep),
              Divider(color: theme.colorScheme.secondary),
              sectionTitle('Forma de Pagamento'),
              infoLine('Pagamento: ', pagamento),
              Divider(color: theme.colorScheme.secondary),
              sectionTitle('Valores'),
              infoLine('Total dos itens: ', valor),
              infoLine('Taxa de entrega: ', taxa),
              infoLine('Valor final: ', total, bold: true),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isAdmin
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: onPressed,
                    child: Text(
                      titleButton ?? '',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      Get.close(0);
                    },
                    child: Text(
                      'FECHAR',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
