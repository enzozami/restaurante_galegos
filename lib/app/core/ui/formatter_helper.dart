import 'package:intl/intl.dart';

class FormatterHelper {
  static final _currentFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
  );

  static final _currentDate = DateFormat.EEEE('pt_BR');

  FormatterHelper._();

  static String formatCurrency(double value) => _currentFormat.format(value);
  static String formatDate = toBeginningOfSentenceCase(_currentDate.format(DateTime.now()));
}
