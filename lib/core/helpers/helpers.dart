import 'package:intl/intl.dart';

class Helpers {
  // ej 45223 => 45 K
  static String numberToHumanRead(double number) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en',
    ).format(number);
    return formattedNumber;
  }
}
