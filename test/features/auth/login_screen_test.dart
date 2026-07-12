import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organize_my_life/core/l10n/generated/app_localizations.dart';
import 'package:organize_my_life/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('mostra o logótipo e o formulário de login sem erros de asset', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LoginScreen(),
      ),
    ));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
