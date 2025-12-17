import 'package:flutter/material.dart';

class CardHistory extends StatelessWidget {
  final VoidCallback onTap;
  final String id;
  final String itens;
  final String price;
  final Widget status;
  final String horario;

  const CardHistory({
    super.key,
    required this.onTap,
    required this.id,
    required this.itens,
    required this.price,
    required this.status,
    required this.horario,
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
            onTap: () {},
            splashColor: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            child: ListTile(
              title: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    id,
                    style: theme.textTheme.titleSmall,
                  ),
                  status,
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Itens: $itens',
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Horário: $horario',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        price,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
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
