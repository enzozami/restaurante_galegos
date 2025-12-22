import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';

class CardHistory extends StatelessWidget {
  final VoidCallback onTap;
  final String id;
  final String itens;
  final String price;
  final Widget status;
  final String horario;
  final String date;

  const CardHistory({
    super.key,
    required this.onTap,
    required this.id,
    required this.itens,
    required this.price,
    required this.status,
    required this.horario,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Card(
          elevation: 5,
          child: InkWell(
            onTap: onTap,
            splashColor: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            child: ListTile(
              title: Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: .start,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Pedido: #$id',
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            '$date, $horario',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.title,
                            ),
                          ),
                        ],
                      ),
                      status,
                    ],
                  ),
                  Text(
                    price,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: .start,
                children: [
                  Divider(),
                  Text(
                    'Carrinho:',
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 16),
                  ),
                  Text(
                    '· $itens',
                    style: theme.textTheme.labelLarge,
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
