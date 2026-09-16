/// Variables de entorno inyectadas en tiempo de compilación o runtime.
/// No expone secretos ni API keys privadas.
class Env {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://placeholder.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'placeholder-anon-key',
  );

  static const String googleMapsApiKeyWeb = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY_WEB',
    defaultValue: '',
  );

  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Indica si la aplicación está operando con credenciales reales o en modo local/demo
  static bool get isConfigured =>
      supabaseUrl != 'https://placeholder.supabase.co' &&
      supabaseAnonKey != 'placeholder-anon-key';
}
