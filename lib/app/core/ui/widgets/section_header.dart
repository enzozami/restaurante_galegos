import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class SectionHeader extends StatelessWidget {
  final List<MultiSelectCard<String>> items;
  final void Function(List<String>, String) onChanged;

  // final MultiSelectController<String> controller;

  const SectionHeader({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return MultiSelectContainer<String>(
      // controller: controller,
      items: items,
      onChange: onChanged,
      itemsDecoration: MultiSelectDecorations(
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
