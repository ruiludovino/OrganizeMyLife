import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preferências globais de UI. Vivem fora de qualquer feature porque
/// Configurações, e o próprio MaterialApp, precisam observá-las.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// null = segue o idioma do sistema (dentre os suportados).
final localeProvider = StateProvider<Locale?>((ref) => null);
