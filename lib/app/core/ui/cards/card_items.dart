import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/cards/card_shimmer.dart';

class CardItems extends StatelessWidget {
  final String titulo;
  final int id;
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
  final bool isSelected;
  final Function(TapDownDetails) onTapDown;
  final Function(TapUpDetails) onTapUp;
  final Function() onTapCancel;
  final RxnInt isPressed;

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
    required this.isSelected,
    required this.onTapDown,
    required this.isPressed,
    required this.onTapUp,
    required this.onTapCancel,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      return SizedBox(
        width: width,
        height: height,
        child: (isProduct)
            ? GestureDetector(
                onTapDown: onTapDown,
                onTapCancel: onTapCancel,
                onTapUp: onTapUp,
                onTap: onTap,
                child: AnimatedScale(
                  scale: isPressed.value == id ? 0.97 : (isSelected ? 1.03 : 1),
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color.fromARGB(255, 190, 132, 98),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: isSelected
                                    // ignore: deprecated_member_use
                                    ? theme.colorScheme.primary.withOpacity(0.2)
                                    // ignore: deprecated_member_use
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: isSelected ? 12 : 6,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
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
                ),
              )
            : GestureDetector(
                onTapDown: onTapDown,
                onTapUp: onTapUp,
                onTapCancel: onTapCancel,
                onTap: onTap,
                child: AnimatedScale(
                  scale: isPressed.value == id ? 0.97 : (isSelected ? 1.03 : 1),
                  duration: const Duration(milliseconds: 200),

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color.fromARGB(255, 190, 132, 98),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: isSelected
                                    // ignore: deprecated_member_use
                                    ? theme.colorScheme.primary.withOpacity(0.2)
                                    // ignore: deprecated_member_use
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: isSelected ? 12 : 6,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
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
                                padding: const EdgeInsets.only(top: 20, right: 15),
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
                                      style: theme.textTheme.bodyMedium,
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
              ),
      );
    });
  }
}
