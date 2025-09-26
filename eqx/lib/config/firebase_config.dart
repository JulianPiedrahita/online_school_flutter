/// Configuración segura de Firebase siguiendo prácticas de OWASP
/// Los API Keys de Firebase para Web son públicos por diseño y seguros
/// Referencia: https://firebase.google.com/docs/projects/api-keys
class FirebaseConfig {
  // Información del proyecto Firebase (valores públicos seguros)
  static const String projectName = 'database-jvs-cloud';
  static const String projectId = 'database-jvs-cloud';
  static const String projectNumber = '904097416357';
  
  // Firebase Web API Key - Es público y seguro según documentación oficial
  // La seguridad se maneja via Firebase Security Rules, no ocultando el API Key
  static const String webApiKey = 'AIzaSyBImccW9tbhiGli-LaRfk-C6QQWGaSIfpw';
  
  // URLs base para Firebase Auth REST API
  static const String _baseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';
  static const String _tokenUrl = 'https://securetoken.googleapis.com/v1/token';
  
  // Endpoints específicos
  static String get signUpUrl => '$_baseUrl:signUp?key=$webApiKey';
  static String get signInUrl => '$_baseUrl:signInWithPassword?key=$webApiKey';
  static String get refreshTokenUrl => '$_tokenUrl?key=$webApiKey';
  static String get getUserDataUrl => '$_baseUrl:lookup?key=$webApiKey';
  static String get updateUserUrl => '$_baseUrl:update?key=$webApiKey';
  static String get deleteUserUrl => '$_baseUrl:delete?key=$webApiKey';
  static String get sendPasswordResetUrl => '$_baseUrl:sendOobCode?key=$webApiKey';
  static String get sendEmailVerificationUrl => '$_baseUrl:sendOobCode?key=$webApiKey';
  
  // Headers comunes para las requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };
  
  // Timeout por defecto para requests
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Configuraciones adicionales
  static const bool enableDebugMode = true;
  static const int maxRetryAttempts = 3;
}