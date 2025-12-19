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
    return AlertDialog(
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
                child: _sectionTitle(context, 'Dados'),
              ),
              _infoLine(context, 'Nome: ', nomeCliente),
              Divider(color: theme.colorScheme.secondary),
              _sectionTitle(context, 'Descrição'),
              _infoLine(context, '', carrinhoName),
              Divider(color: theme.colorScheme.secondary),
              _sectionTitle(context, 'Detalhes'),
              _infoLine(context, 'Data: ', data),
              _infoLine(context, 'Horário do pedido: ', horarioInicio),
              Visibility(
                visible: isAdmin,
                child: _infoLine(context, 'Horário entrega: ', horarioSairEntrega),
              ),
              _infoLine(context, 'Horário entregue: ', horarioEntregue),
              Divider(color: theme.colorScheme.secondary),
              _sectionTitle(context, 'Endereço:'),
              _infoLine(context, 'Rua: ', rua),
              _infoLine(context, 'Número: ', numeroResidencia),
              _infoLine(context, 'Bairro: ', bairro),
              _infoLine(context, 'Cidade: ', cidade),
              _infoLine(context, 'Estado: ', estado),
              _infoLine(context, 'CEP: ', cep),
              Divider(color: theme.colorScheme.secondary),
              _sectionTitle(context, 'Forma de Pagamento'),
              _infoLine(context, 'Pagamento: ', pagamento),
              Divider(color: theme.colorScheme.secondary),
              _sectionTitle(context, 'Valores'),
              _infoLine(context, 'Total dos itens: ', valor),
              _infoLine(context, 'Taxa de entrega: ', taxa),
              _infoLine(context, 'Valor final: ', total, bold: true),
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

Widget _sectionTitle(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
  child: Text(text, style: Theme.of(context).textTheme.titleSmall),
);

Widget _infoLine(BuildContext context, String label, String value, {bool bold = false}) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
  child: Text(
    '$label$value',
    style: bold
        ? TextStyle(
            color: AppColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )
        : Theme.of(context).textTheme.bodyLarge,
  ),
);


/* 

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

*/