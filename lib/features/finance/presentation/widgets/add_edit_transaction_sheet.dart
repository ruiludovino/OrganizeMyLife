import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_providers.dart';

Future<void> showAddEditTransactionSheet(BuildContext context, {MoneyTransaction? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddEditTransactionSheet(existing: existing),
  );
}

class _AddEditTransactionSheet extends ConsumerStatefulWidget {
  const _AddEditTransactionSheet({this.existing});

  final MoneyTransaction? existing;

  @override
  ConsumerState<_AddEditTransactionSheet> createState() => _AddEditTransactionSheetState();
}

class _AddEditTransactionSheetState extends ConsumerState<_AddEditTransactionSheet> {
  late final _titleController = TextEditingController(text: widget.existing?.title);
  late final _amountController = TextEditingController(
    text: widget.existing == null ? '' : widget.existing!.amount.toStringAsFixed(2),
  );
  late final _categoryController = TextEditingController(text: widget.existing?.category);

  late TransactionType _type = widget.existing?.type ?? TransactionType.expense;
  late DateTime _date = widget.existing?.date ?? DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    final category = _categoryController.text.trim();
    if (title.isEmpty || amount == null || amount <= 0 || category.isEmpty) return;

    setState(() => _saving = true);
    final repo = ref.read(transactionRepositoryProvider);

    final transaction = (widget.existing ??
            MoneyTransaction(
              id: repo.newId(),
              title: title,
              amount: amount,
              type: _type,
              category: category,
              date: _date,
            ))
        .copyWith(title: title, amount: amount, type: _type, category: category, date: _date);

    if (widget.existing == null) {
      await repo.addTransaction(transaction);
    } else {
      await repo.updateTransaction(transaction);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<TransactionType>(
            segments: [
              ButtonSegment(
                value: TransactionType.expense,
                label: Text(l10n.financeExpense),
                icon: const Icon(Icons.arrow_downward, color: AppColors.expense),
              ),
              ButtonSegment(
                value: TransactionType.income,
                label: Text(l10n.financeIncome),
                icon: const Icon(Icons.arrow_upward, color: AppColors.income),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: l10n.financeDescriptionLabel, controller: _titleController),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.financeAmount,
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: l10n.financeCategory, controller: _categoryController),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.event_outlined),
            label: Text('${_date.day}/${_date.month}/${_date.year}'),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: l10n.commonSave, loading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}
