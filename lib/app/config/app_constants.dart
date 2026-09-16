/// Configuración de constantes globales y branding de la aplicación.
/// Permite cambiar el nombre comercial o defaults fácilmente en un único lugar.
class AppConstants {
  // Branding (Fácilmente modificable)
  static const String appName = 'Triply';
  static const String appTagline = 'El sistema operativo del viaje grupal.';
  static const String appSubheadline =
      'Organizá el viaje con tus amigos, centralizá reservas, voten qué hacer, '
      'controlen gastos y dejá que la IA se encargue del caos.';

  // Default currencies
  static const String defaultCurrency = 'USD';
  static const List<String> supportedCurrencies = ['USD', 'EUR', 'ARS', 'BRL', 'MXN', 'GBP'];

  // Límites
  static const int maxTravelersPerTrip = 50;
  static const int maxUploadSizeBytes = 15 * 1024 * 1024; // 15MB
}
