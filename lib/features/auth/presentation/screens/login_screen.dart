import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../auth_error_localizer.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final controller = ref.read(loginControllerProvider.notifier);
    final ok = await controller.submit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!ok && mounted) {
      final error = ref.read(loginControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizeAuthError(l10n, error!))),
      );
    }
    // Sucesso: authStateProvider muda -> router redireciona sozinho.
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(loginControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Center(
            child: SingleChildScrollView(
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset('assets/images/logo.jpg', height: 96),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(l10n.authLoginTitle, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(l10n.authLoginSubtitle, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      label: l10n.authEmailLabel,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: l10n.authPasswordLabel,
                      controller: _passwordController,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: Text(l10n.authForgotPassword),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: l10n.authLoginButton,
                      loading: state.isLoading,
                      onPressed: () => _submit(l10n),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: TextButton(
                        onPressed: () => context.push('/signup'),
                        child: Text(l10n.authNoAccount(l10n.authSignUpAction)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
