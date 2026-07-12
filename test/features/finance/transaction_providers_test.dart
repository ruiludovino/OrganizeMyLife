import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organize_my_life/features/finance/domain/entities/transaction.dart';
import 'package:organize_my_life/features/finance/presentation/providers/transaction_providers.dart';

import '../../helpers/fake_repositories.dart';

MoneyTransaction _tx({
  required String id,
  required double amount,
  required TransactionType type,
  required DateTime date,
  String category = 'Geral',
}) {
  return MoneyTransaction(
    id: id,
    title: 'Tx $id',
    amount: amount,
    type: type,
    category: category,
    date: date,
  );
}

void main() {
  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month, 10);
  final lastMonth = DateTime(now.year, now.month - 1, 10);

  group('currentMonthSummaryProvider', () {
    test('soma receitas e despesas só do mês corrente', () async {
      final container = ProviderContainer(overrides: [
        transactionRepositoryProvider.overrideWithValue(FakeTransactionRepository([
          _tx(id: '1', amount: 1000, type: TransactionType.income, date: thisMonth),
          _tx(id: '2', amount: 300, type: TransactionType.expense, date: thisMonth),
          _tx(id: '3', amount: 500, type: TransactionType.income, date: lastMonth),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(transactionsProvider.future);
      final summary = container.read(currentMonthSummaryProvider);

      expect(summary.income, 1000);
      expect(summary.expense, 300);
      expect(summary.balance, 700);
    });
  });

  group('currentMonthExpenseByCategoryProvider', () {
    test('agrupa despesas do mês corrente por categoria, ignorando receitas e outros meses', () async {
      final container = ProviderContainer(overrides: [
        transactionRepositoryProvider.overrideWithValue(FakeTransactionRepository([
          _tx(id: '1', amount: 100, type: TransactionType.expense, date: thisMonth, category: 'Mercado'),
          _tx(id: '2', amount: 50, type: TransactionType.expense, date: thisMonth, category: 'Mercado'),
          _tx(id: '3', amount: 80, type: TransactionType.expense, date: thisMonth, category: 'Transporte'),
          _tx(id: '4', amount: 999, type: TransactionType.income, date: thisMonth, category: 'Mercado'),
          _tx(id: '5', amount: 40, type: TransactionType.expense, date: lastMonth, category: 'Mercado'),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(transactionsProvider.future);
      final byCategory = container.read(currentMonthExpenseByCategoryProvider);

      expect(byCategory['Mercado'], 150);
      expect(byCategory['Transporte'], 80);
      expect(byCategory.length, 2);
    });
  });

  group('sixMonthTrendProvider', () {
    test('inclui o mês corrente e os 5 anteriores, com totais corretos', () async {
      final container = ProviderContainer(overrides: [
        transactionRepositoryProvider.overrideWithValue(FakeTransactionRepository([
          _tx(id: '1', amount: 200, type: TransactionType.income, date: thisMonth),
          _tx(id: '2', amount: 120, type: TransactionType.expense, date: lastMonth),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(transactionsProvider.future);
      final trend = container.read(sixMonthTrendProvider);

      expect(trend.length, 6);
      expect(trend.last.month.year, now.year);
      expect(trend.last.month.month, now.month);
      expect(trend.last.income, 200);
      expect(trend[4].expense, 120);
    });
  });
}
