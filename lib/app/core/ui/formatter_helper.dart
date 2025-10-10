import 'package:intl/intl.dart';

class FormatterHelper {
  static final _currentFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
  );

  FormatterHelper._();

  static String formatCurrency(double value) => _currentFormat.format(value);
}
