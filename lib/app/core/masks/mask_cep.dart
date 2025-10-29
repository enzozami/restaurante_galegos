import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskCep extends MaskTextInputFormatter {
  MaskCep()
      : super(
          mask: '#####-###',
          filter: {
            '#': RegExp(r'[0-9]'),
          },
        );
}

class MaskCepReverse extends MaskTextInputFormatter {
  MaskCepReverse()
      : super(
          mask: '########',
          filter: {
            '#': RegExp(r'[0-9]'),
          },
        );
}
