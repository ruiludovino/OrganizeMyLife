enum TransactionType { income, expense }

/// Chamada `MoneyTransaction` (não `Transaction`) para não colidir com
/// `cloud_firestore`, que já exporta uma classe `Transaction` própria.
class MoneyTransaction {
  const MoneyTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;

  /// Sempre positivo — o sinal vem de [type].
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;

  double get signedAmount => type == TransactionType.income ? amount : -amount;

  MoneyTransaction copyWith({
    String? title,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
  }) {
    return MoneyTransaction(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}
