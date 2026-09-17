/// Variables de entorno inyectadas en tiempo de compilación o runtime.
/// No expone secretos ni API keys privadas.
class Env {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vxhnxnlvckzunivqrbge.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_u4JU36HGBB5O0lI3RY9fiw_u8eUyh7T',
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
      supabaseUrl.isNotEmpty &&
      supabaseUrl != 'https://placeholder.supabase.co' &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey != 'placeholder-anon-key';
}
