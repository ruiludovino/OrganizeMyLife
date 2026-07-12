import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_transaction_repository.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    throw StateError('transactionRepositoryProvider só pode ser lido com usuário autenticado');
  }
  return FirestoreTransactionRepository(FirebaseFirestore.instance, userId: user.id);
});

final transactionsProvider = StreamProvider<List<MoneyTransaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchTransactions();
});

DateTime _firstOfMonth(DateTime d) => DateTime(d.year, d.month);

/// Mês em exibição na tela de Finanças — sempre normalizado para o dia 1.
final selectedMonthProvider = StateProvider<DateTime>((ref) => _firstOfMonth(DateTime.now()));

bool _isInMonth(DateTime date, DateTime month) =>
    date.year == month.year && date.month == month.month;

final monthlyTransactionsProvider = Provider<List<MoneyTransaction>>((ref) {
  final all = ref.watch(transactionsProvider).value ?? const [];
  final month = ref.watch(selectedMonthProvider);
  return all.where((t) => _isInMonth(t.date, month)).toList();
});

class MonthlySummary {
  const MonthlySummary({required this.income, required this.expense});

  final double income;
  final double expense;

  double get balance => income - expense;
}

MonthlySummary _summarize(List<MoneyTransaction> transactions) {
  double income = 0;
  double expense = 0;
  for (final t in transactions) {
    if (t.type == TransactionType.income) {
      income += t.amount;
    } else {
      expense += t.amount;
    }
  }
  return MonthlySummary(income: income, expense: expense);
}

final monthlySummaryProvider = Provider<MonthlySummary>((ref) {
  return _summarize(ref.watch(monthlyTransactionsProvider));
});

/// Resumo do mês corrente, independente do mês que o usuário está
/// navegando na tela de Finanças — é o que o dashboard "Hoje" usa.
final currentMonthSummaryProvider = Provider<MonthlySummary>((ref) {
  final all = ref.watch(transactionsProvider).value ?? const [];
  final now = _firstOfMonth(DateTime.now());
  return _summarize(all.where((t) => _isInMonth(t.date, now)).toList());
});

Map<String, double> _expenseByCategory(List<MoneyTransaction> transactions) {
  final map = <String, double>{};
  for (final t in transactions.where((t) => t.type == TransactionType.expense)) {
    map.update(t.category, (v) => v + t.amount, ifAbsent: () => t.amount);
  }
  return map;
}

/// Total de despesas por categoria no mês selecionado — alimenta o
/// gráfico de pizza da aba Finanças.
final expenseByCategoryProvider = Provider<Map<String, double>>((ref) {
  return _expenseByCategory(ref.watch(monthlyTransactionsProvider));
});

/// Total de despesas por categoria no mês corrente — independe do mês que
/// o usuário está navegando na aba Finanças. Alimenta o gráfico de
/// Relatórios.
final currentMonthExpenseByCategoryProvider = Provider<Map<String, double>>((ref) {
  final all = ref.watch(transactionsProvider).value ?? const [];
  final now = _firstOfMonth(DateTime.now());
  return _expenseByCategory(all.where((t) => _isInMonth(t.date, now)).toList());
});

class MonthlyTotals {
  const MonthlyTotals({required this.month, required this.income, required this.expense});

  final DateTime month;
  final double income;
  final double expense;
}

/// Receita x despesa nos últimos 6 meses (incluindo o atual) — alimenta
/// o gráfico de barras. Independe do mês selecionado na tela.
final sixMonthTrendProvider = Provider<List<MonthlyTotals>>((ref) {
  final all = ref.watch(transactionsProvider).value ?? const [];
  final now = _firstOfMonth(DateTime.now());
  final months = List.generate(6, (i) => DateTime(now.year, now.month - (5 - i)));

  return months.map((month) {
    double income = 0;
    double expense = 0;
    for (final t in all.where((t) => _isInMonth(t.date, month))) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return MonthlyTotals(month: month, income: income, expense: expense);
  }).toList();
});
