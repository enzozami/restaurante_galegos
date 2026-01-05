import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GalegosMask extends MaskTextInputFormatter {
  GalegosMask()
    : super(
        mask: '(##) #####-####',
        filter: {
          '#': RegExp(r'[0-9]'),
        },
      );
}
