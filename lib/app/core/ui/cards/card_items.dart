import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_shimmer.dart';

class CardItems extends StatelessWidget {
  final String titulo;
  final String? descricao;
  final String? preco;
  final String? precoMini;
  final String? precoMedia;
  final String? image;
  final VoidCallback onPressed;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? imageHeight;
  final TextStyle? styleTitle;
  final TextStyle? styleDescricao;
  final TextStyle? stylePreco;
  final bool isProduct;
  final Widget? elevatedButton;

  const CardItems({
    super.key,
    required this.titulo,
    this.descricao,
    this.preco,
    this.precoMini,
    this.precoMedia,
    required this.onPressed,
    required this.onTap,
    this.image,
    required this.styleTitle,
    required this.styleDescricao,
    required this.stylePreco,
    required this.isProduct,
    this.width,
    this.height,
    this.imageHeight,
    this.elevatedButton,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: (isProduct)
          ? Card(
              elevation: theme.cardTheme.elevation,
              color: theme.cardTheme.color,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 190, 132, 98),
                ),
              ),
              child: InkWell(
                onTap: onTap,
                splashColor: theme.splashColor,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    (image != null && image != '')
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: double.infinity,
                            height: imageHeight ?? 150,
                            child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadiusGeometry.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                image ?? '',
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) =>
                                    loadingProgress == null
                                    ? child
                                    : CardShimmer(
                                        height: imageHeight ?? 0,
                                        width: width ?? 0,
                                      ),
                              ),
                            ),
                          )
                        : SizedBox(height: 120),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        titulo,
                        style: styleTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        descricao ?? '',
                        style: styleDescricao,
                        textAlign: TextAlign.start,

                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(preco ?? '', style: stylePreco),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            onPressed: onPressed,
                            icon: Icon(
                              Icons.add,
                              color: theme.colorScheme.surface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Card(
              elevation: theme.cardTheme.elevation,
              color: theme.cardTheme.color,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 190, 132, 98),
                ),
              ),
              child: InkWell(
                onTap: onTap,
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  spacing: 25,
                  children: [
                    Row(
                      children: [
                        (image != null && image != '')
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                  right: 20,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: context.widthTransformer(reducedBy: 65),
                                  height: 130,
                                  child: ClipRRect(
                                    clipBehavior: Clip.antiAlias,
                                    borderRadius: BorderRadiusGeometry.circular(
                                      20,
                                    ),
                                    child: Image.network(
                                      image ?? '',
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) =>
                                          loadingProgress == null
                                          ? child
                                          : CardShimmer(
                                              height: imageHeight ?? 0,
                                              width: width ?? 0,
                                            ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                  right: 20,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: theme.colorScheme.secondary,
                                  ),
                                  width: context.widthTransformer(reducedBy: 65),
                                  height: 130,
                                ),
                              ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              mainAxisAlignment: .start,
                              crossAxisAlignment: .start,
                              spacing: 15,
                              children: [
                                Text(
                                  titulo,
                                  style: theme.textTheme.titleLarge,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  descricao ?? '',
                                  style: theme.textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
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
