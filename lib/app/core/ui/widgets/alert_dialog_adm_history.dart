import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class AlertDialogAdmHistory extends StatelessWidget {
  final String pedidoLabel;
  final String carrinhoName;
  final String valor;
  final String taxa;
  final String total;
  final String nomeCliente;
  final String cpfOrCnpj;
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

  const AlertDialogAdmHistory({
    super.key,
    required this.pedidoLabel,
    required this.carrinhoName,
    required this.valor,
    required this.taxa,
    required this.total,
    required this.nomeCliente,
    required this.cpfOrCnpj,
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
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      titlePadding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      actionsPadding: const EdgeInsets.all(20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Pedido: $pedidoLabel',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Container(
        decoration: BoxDecoration(
          color: GalegosUiDefaut.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dados:',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Nome: $nomeCliente',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                cpfOrCnpj,
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Divider(
                color: Colors.black,
              ),
              Text(
                'Descrição:',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                carrinhoName,
                style: const TextStyle(color: Colors.black),
              ),
              Divider(
                color: Colors.black,
              ),
              Text(
                'Detalhes:',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data,
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text('Horário do pedido: $horarioInicio'),
              Text('Horário entrega: $horarioSairEntrega'),
              Text('Horário entregue: $horarioEntregue'),
              Divider(
                color: Colors.black,
              ),
              Text(
                'Endereço:',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rua: $rua',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Número: $numeroResidencia',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Bairro: $bairro',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Cidade: $cidade',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Estado: $estado',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'CEP: $cep',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Divider(
                color: Colors.black,
              ),
              Text(
                'Total dos itens: $valor',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Taxa de entrega: $taxa',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Valor final: $total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: statusPedido == 'entregue',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GalegosUiDefaut.colorScheme.error,
                ),
                onPressed: () {
                  Get.close(0);
                },
                child: Text(
                  'FECHAR',
                  style: TextStyle(
                    color: GalegosUiDefaut.colorScheme.onError,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GalegosUiDefaut.colorScheme.primary,
              ),
              onPressed: onPressed,
              child: Text(
                statusPedido,
                style: TextStyle(color: GalegosUiDefaut.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
