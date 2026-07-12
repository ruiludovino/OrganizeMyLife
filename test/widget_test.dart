import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:organize_my_life/core/providers/push_token_providers.dart';
import 'package:organize_my_life/features/auth/presentation/providers/auth_providers.dart';
import 'package:organize_my_life/main.dart';

import 'helpers/fake_repositories.dart';

void main() {
  testWidgets('App builds and shows the login screen when signed out', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        // Evita tocar no FirebaseMessaging real (não inicializado no teste).
        pushTokenSyncProvider.overrideWith((ref) {}),
      ],
      child: const OrganizeMyLifeApp(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
