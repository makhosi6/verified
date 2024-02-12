import 'package:intl/intl.dart';

String formatCurrency(balance, String? isoCurrencyCode) {
  const CENTS = 100;
  const ONE_THOUSAND_RANDS = 100000;

  /// if the amount is less than R1000, show cents.
  int decimalDigits = (balance < ONE_THOUSAND_RANDS) ? 2 : 0;

  return NumberFormat.currency(locale: 'en_US', symbol: isoCurrencyCode ?? 'R', decimalDigits: decimalDigits)
      .format(balance / CENTS)
      .replaceAll('.', ',');
}
