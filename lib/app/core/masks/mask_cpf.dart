import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskCpf extends MaskTextInputFormatter {
  MaskCpf()
      : super(
          mask: '###.###.###-##',
          filter: {
            '#': RegExp(r'[0-9]'),
          },
        );
}
