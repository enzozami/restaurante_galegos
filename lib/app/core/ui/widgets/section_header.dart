import 'package:flutter/widgets.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class SectionHeader extends StatelessWidget {
  final List<MultiSelectCard<String>> items;
  final void Function(List<String>, String) onChanged;
  // final MultiSelectController<String> controller;

  const SectionHeader({super.key, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return MultiSelectContainer<String>(
      // controller: controller,
      items: items,
      onChange: onChanged,
      itemsDecoration: MultiSelectDecorations(
        selectedDecoration: BoxDecoration(
          color: GalegosUiDefaut.colorScheme.primary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
        ),
        decoration: BoxDecoration(
          color: GalegosUiDefaut.colorScheme.secondary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
