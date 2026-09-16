import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/config/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase si los parámetros de entorno fueron provistos
  if (Env.isConfigured) {
    try {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        publishableKey: Env.supabaseAnonKey,
      );
    } catch (e) {
      debugPrint('Error al inicializar Supabase: $e');
    }
  } else {
    debugPrint('Triply corriendo en modo demo/desarrollo local.');
  }

  runApp(
    const ProviderScope(
      child: TriplyApp(),
    ),
  );
}
