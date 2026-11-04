import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat _numberFormat = NumberFormat('#,##0.#', 'id_ID');

  static String formatRupiah(num amount) {
    return _currencyFormat.format(amount);
  }

  static String formatNumber(num value) {
    return _numberFormat.format(value);
  }

  static String formatWeight(num weightKg) {
    return '${_numberFormat.format(weightKg)} kg';
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }
}

