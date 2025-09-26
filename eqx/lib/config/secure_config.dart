/// Configuración segura de entorno para Flutter Web
/// Implementa mejores prácticas de OWASP para manejo de credenciales
class SecureConfig {
  // Configuración estática para desarrollo (valores públicos seguros)
  static const String _devGoogleClientId = 'development-client-id';
  static const String _prodGoogleClientId = 'production-client-id';
  
  // Configuración de entorno
  static const bool _isProduction = bool.fromEnvironment('dart.vm.product');
  static const String _environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  
  /// Obtiene el Google Client ID de forma segura
  /// En desarrollo: usa configuración local
  /// En producción: se debe configurar via variables de entorno del servidor
  static String getGoogleClientId() {
    // Para web, el client ID puede ser público pero debe estar controlado
    // Esta es una excepción en OAuth2 - el Client ID no es secreto
    return _isProduction ? _prodGoogleClientId : _devGoogleClientId;
  }
  
  /// Verifica si estamos en modo de desarrollo
  static bool get isDevelopment => _environment == 'development';
  
  /// Obtiene el dominio permitido para OAuth redirects
  static String getAllowedDomain() {
    return _isProduction ? 'your-production-domain.com' : 'localhost';
  }
  
  /// Configuración de CORS segura
  static List<String> getAllowedOrigins() {
    return _isProduction 
      ? ['https://your-production-domain.com']
      : ['http://localhost:3000', 'http://localhost:8080'];
  }
}