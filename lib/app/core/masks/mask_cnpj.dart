import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskCnpj extends MaskTextInputFormatter {
  MaskCnpj()
      : super(
          mask: '##.###.###/####-##',
          filter: {
            '#': RegExp(r'[0-9]'),
          },
        );
}
