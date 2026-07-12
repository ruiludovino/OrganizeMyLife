import 'package:intl/intl.dart';

/// Formatação de moeda simples baseada no idioma ativo. Não é uma
/// preferência de moeda de verdade (fora de escopo por ora) — só evita
/// mostrar números nus na tela de Finanças.
String formatCurrency(double value, String languageCode) {
  final symbol = languageCode == 'pt' ? 'R\$' : r'$';
  final format = NumberFormat.currency(locale: languageCode, symbol: symbol, decimalDigits: 2);
  return format.format(value);
}
