import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class CardItems extends StatelessWidget {
  final String titulo;
  final String? descricao;
  final String preco;
  final String? image;
  final VoidCallback onPressed;
  final VoidCallback onTap;

  const CardItems({
    super.key,
    required this.titulo,
    this.descricao,
    required this.preco,
    required this.onPressed,
    required this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 310,
      child: Card(
        elevation: GalegosUiDefaut.theme.cardTheme.elevation,
        color: GalegosUiDefaut.theme.cardTheme.color,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: GalegosUiDefaut.colorScheme.tertiary),
        ),
        child: InkWell(
          onTap: onTap,
          splashColor: GalegosUiDefaut.theme.splashColor,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: context.width,
                  height: 120,
                  child: Image.network(image ?? '', fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  titulo,
                  style: GalegosUiDefaut.theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  descricao ?? '',
                  style: GalegosUiDefaut.theme.textTheme.bodySmall,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(preco, style: GalegosUiDefaut.textPrice.titleMedium),
                  Container(
                    decoration: BoxDecoration(
                      color: GalegosUiDefaut.colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(onPressed: onPressed, icon: Icon(Icons.add)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
