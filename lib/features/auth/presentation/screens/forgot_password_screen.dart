import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../auth_error_localizer.dart';
import '../providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final controller = ref.read(forgotPasswordControllerProvider.notifier);
    final ok = await controller.submit(_emailController.text.trim());
    if (!mounted) return;

    if (ok) {
      setState(() => _sent = true);
    } else {
      final error = ref.read(forgotPasswordControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizeAuthError(l10n, error!))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(forgotPasswordControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.authResetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xl),
              if (_sent) ...[
                Text(l10n.authResetPasswordSent(_emailController.text.trim())),
              ] else ...[
                AutofillGroup(
                  child: AppTextField(
                    label: l10n.authEmailLabel,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: l10n.authSendResetLink,
                  loading: state.isLoading,
                  onPressed: () => _submit(l10n),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
