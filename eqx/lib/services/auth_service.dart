import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eqx/models/user_model.dart';
import 'package:eqx/config/firebase_config.dart';

// Enums para manejar estados
enum AuthStatus { authenticated, unauthenticated, loading }

enum AuthError { 
  invalidCredentials, 
  emailAlreadyExists, 
  weakPassword, 
  networkError, 
  serverError,
  unknown,
  // Errores específicos de Firebase
  emailNotFound,
  invalidPassword,
  userDisabled,
  operationNotAllowed,
  tooManyAttempts,
  credentialTooOld,
  tokenExpired,
  userNotFound,
  invalidIdToken,
  invalidEmail
}

// Clase de resultado para operaciones de autenticación
class AuthResult {
  final bool success;
  final User? user;
  final AuthError? error;
  final String? message;
  final String? idToken;
  final String? refreshToken;
  final FirebaseAuthResponse? firebaseResponse;

  AuthResult({
    required this.success,
    this.user,
    this.error,
    this.message,
    this.idToken,
    this.refreshToken,
    this.firebaseResponse,
  });

  factory AuthResult.success(User user, {String? idToken, String? refreshToken, FirebaseAuthResponse? firebaseResponse}) {
    return AuthResult(
      success: true,
      user: user,
      idToken: idToken,
      refreshToken: refreshToken,
      firebaseResponse: firebaseResponse,
    );
  }

  factory AuthResult.failure(AuthError error, [String? message]) {
    return AuthResult(
      success: false,
      error: error,
      message: message,
    );
  }
}

// Servicio de autenticación (simulado)
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Stream controller para el estado de autenticación
  final _authStatusController = StreamController<AuthStatus>.broadcast();
  final _userController = StreamController<User?>.broadcast();

  Stream<AuthStatus> get authStatusStream => _authStatusController.stream;
  Stream<User?> get userStream => _userController.stream;

  AuthStatus _currentStatus = AuthStatus.unauthenticated;
  User? _currentUser;
  String? _currentIdToken;
  String? _currentRefreshToken;
  FirebaseAuthResponse? _currentFirebaseResponse;

  AuthStatus get currentStatus => _currentStatus;
  User? get currentUser => _currentUser;
  String? get currentIdToken => _currentIdToken;
  String? get currentRefreshToken => _currentRefreshToken;
  FirebaseAuthResponse? get currentFirebaseResponse => _currentFirebaseResponse;

  // Método de login con Firebase Auth REST API
  Future<AuthResult> login(LoginCredentials credentials) async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Validar formato de email
      if (!_isValidEmail(credentials.email)) {
        _setStatus(AuthStatus.unauthenticated);
        return AuthResult.failure(
          AuthError.invalidEmail, 
          'Formato de email inválido'
        );
      }

      // Validar contraseña mínima
      if (credentials.password.length < 6) {
        _setStatus(AuthStatus.unauthenticated);
        return AuthResult.failure(
          AuthError.weakPassword,
          'La contraseña debe tener al menos 6 caracteres'
        );
      }

      // Preparar datos para Firebase
      final requestBody = {
        'email': credentials.email,
        'password': credentials.password,
        'returnSecureToken': true,
      };

      // Llamada a Firebase Auth REST API
      final response = await http.post(
        Uri.parse(FirebaseConfig.signInUrl),
        headers: FirebaseConfig.headers,
        body: jsonEncode(requestBody),
      ).timeout(FirebaseConfig.requestTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login exitoso
        final firebaseResponse = FirebaseAuthResponse.fromJson(responseData);
        
        // Crear usuario a partir de los datos de Firebase
        final user = User(
          id: firebaseResponse.localId ?? '',
          firstName: _extractFirstName(firebaseResponse.displayName),
          lastName: _extractLastName(firebaseResponse.displayName),
          email: firebaseResponse.email ?? credentials.email,
          phone: '', // Firebase Auth no maneja teléfono por defecto
          city: '',
          address: '',
          createdAt: DateTime.now(),
        );

        // Guardar datos de sesión
        _currentUser = user;
        _currentIdToken = firebaseResponse.idToken;
        _currentRefreshToken = firebaseResponse.refreshToken;
        _currentFirebaseResponse = firebaseResponse;
        
        _setStatus(AuthStatus.authenticated);
        _userController.add(_currentUser);

        if (FirebaseConfig.enableDebugMode) {
          print('Firebase Login Success: ${firebaseResponse.localId}');
        }

        return AuthResult.success(
          user,
          idToken: firebaseResponse.idToken,
          refreshToken: firebaseResponse.refreshToken,
          firebaseResponse: firebaseResponse,
        );
      } else {
        // Manejar errores de Firebase
        return _handleFirebaseError(responseData);
      }

    } on TimeoutException {
      _setStatus(AuthStatus.unauthenticated);
      return AuthResult.failure(
        AuthError.networkError,
        'Tiempo de espera agotado. Verifica tu conexión a internet.'
      );
    } catch (e) {
      _setStatus(AuthStatus.unauthenticated);
      if (FirebaseConfig.enableDebugMode) {
        print('Login Error: $e');
      }
      return AuthResult.failure(
        AuthError.unknown,
        'Error inesperado: ${e.toString()}'
      );
    }
  }

  // Método de registro con Firebase Auth REST API
  Future<AuthResult> register(RegisterData registerData) async {
    try {
      _setStatus(AuthStatus.loading);

      // Validar datos básicos
      if (!registerData.isValid) {
        _setStatus(AuthStatus.unauthenticated);
        return AuthResult.failure(
          AuthError.weakPassword,
          'Datos de registro inválidos'
        );
      }

      // Validar formato de email
      if (!_isValidEmail(registerData.email)) {
        _setStatus(AuthStatus.unauthenticated);
        return AuthResult.failure(
          AuthError.invalidEmail,
          'Formato de email inválido'
        );
      }

      // Validar fortaleza de contraseña
      if (!_isStrongPassword(registerData.password)) {
        _setStatus(AuthStatus.unauthenticated);
        return AuthResult.failure(
          AuthError.weakPassword,
          'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número'
        );
      }

      // Preparar datos para Firebase
      final requestBody = {
        'email': registerData.email,
        'password': registerData.password,
        'returnSecureToken': true,
      };

      // Llamada a Firebase Auth REST API para registro
      final response = await http.post(
        Uri.parse(FirebaseConfig.signUpUrl),
        headers: FirebaseConfig.headers,
        body: jsonEncode(requestBody),
      ).timeout(FirebaseConfig.requestTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Registro exitoso
        final firebaseResponse = FirebaseAuthResponse.fromJson(responseData);
        
        // Crear usuario con datos del registro
        final newUser = User(
          id: firebaseResponse.localId ?? '',
          firstName: registerData.firstName,
          lastName: registerData.lastName,
          email: firebaseResponse.email ?? registerData.email,
          phone: registerData.phone,
          city: registerData.city,
          address: registerData.address,
          createdAt: DateTime.now(),
        );

        // Guardar datos de sesión
        _currentUser = newUser;
        _currentIdToken = firebaseResponse.idToken;
        _currentRefreshToken = firebaseResponse.refreshToken;
        _currentFirebaseResponse = firebaseResponse;
        
        _setStatus(AuthStatus.authenticated);
        _userController.add(_currentUser);

        if (FirebaseConfig.enableDebugMode) {
          print('Firebase Register Success: ${firebaseResponse.localId}');
        }

        // TODO: Opcional - Actualizar perfil de usuario en Firebase con displayName
        await _updateUserProfile(newUser.fullName);

        return AuthResult.success(
          newUser,
          idToken: firebaseResponse.idToken,
          refreshToken: firebaseResponse.refreshToken,
          firebaseResponse: firebaseResponse,
        );
      } else {
        // Manejar errores de Firebase
        return _handleFirebaseError(responseData);
      }

    } on TimeoutException {
      _setStatus(AuthStatus.unauthenticated);
      return AuthResult.failure(
        AuthError.networkError,
        'Tiempo de espera agotado. Verifica tu conexión a internet.'
      );
    } catch (e) {
      _setStatus(AuthStatus.unauthenticated);
      if (FirebaseConfig.enableDebugMode) {
        print('Register Error: $e');
      }
      return AuthResult.failure(
        AuthError.unknown,
        'Error inesperado: ${e.toString()}'
      );
    }
  }

  // Método de logout
  Future<void> logout() async {
    _currentUser = null;
    _currentIdToken = null;
    _currentRefreshToken = null;
    _currentFirebaseResponse = null;
    _setStatus(AuthStatus.unauthenticated);
    _userController.add(null);
    
    if (FirebaseConfig.enableDebugMode) {
      print('User logged out successfully');
    }
  }

  // Validación de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validación de contraseña fuerte
  bool _isStrongPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$')
        .hasMatch(password);
  }

  // Validación de teléfono colombiano
  bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  // Manejar errores específicos de Firebase
  AuthResult _handleFirebaseError(Map<String, dynamic> responseData) {
    _setStatus(AuthStatus.unauthenticated);
    
    final firebaseError = FirebaseAuthError.fromJson(responseData);
    final errorMessage = firebaseError.message;
    
    // Mapear errores de Firebase a nuestros AuthError
    AuthError authError;
    String userMessage;
    
    switch (errorMessage) {
      case 'EMAIL_EXISTS':
        authError = AuthError.emailAlreadyExists;
        userMessage = 'Este email ya está registrado';
        break;
      case 'EMAIL_NOT_FOUND':
        authError = AuthError.emailNotFound;
        userMessage = 'No se encontró una cuenta con este email';
        break;
      case 'INVALID_PASSWORD':
        authError = AuthError.invalidPassword;
        userMessage = 'Contraseña incorrecta';
        break;
      case 'USER_DISABLED':
        authError = AuthError.userDisabled;
        userMessage = 'Esta cuenta ha sido deshabilitada';
        break;
      case 'TOO_MANY_ATTEMPTS_TRY_LATER':
        authError = AuthError.tooManyAttempts;
        userMessage = 'Demasiados intentos. Intenta más tarde';
        break;
      case 'OPERATION_NOT_ALLOWED':
        authError = AuthError.operationNotAllowed;
        userMessage = 'Esta operación no está permitida';
        break;
      case 'WEAK_PASSWORD':
        authError = AuthError.weakPassword;
        userMessage = 'La contraseña es muy débil';
        break;
      case 'INVALID_EMAIL':
        authError = AuthError.invalidEmail;
        userMessage = 'Formato de email inválido';
        break;
      default:
        authError = AuthError.serverError;
        userMessage = 'Error del servidor: $errorMessage';
    }
    
    if (FirebaseConfig.enableDebugMode) {
      print('Firebase Error: $errorMessage');
    }
    
    return AuthResult.failure(authError, userMessage);
  }

  // Extraer primer nombre del displayName
  String _extractFirstName(String? displayName) {
    if (displayName == null || displayName.isEmpty) return '';
    final names = displayName.split(' ');
    return names.isNotEmpty ? names.first : '';
  }

  // Extraer apellido del displayName
  String _extractLastName(String? displayName) {
    if (displayName == null || displayName.isEmpty) return '';
    final names = displayName.split(' ');
    return names.length > 1 ? names.sublist(1).join(' ') : '';
  }

  // Actualizar perfil de usuario en Firebase
  Future<void> _updateUserProfile(String displayName) async {
    if (_currentIdToken == null) return;
    
    try {
      final requestBody = {
        'idToken': _currentIdToken,
        'displayName': displayName,
        'returnSecureToken': false,
      };

      await http.post(
        Uri.parse(FirebaseConfig.updateUserUrl),
        headers: FirebaseConfig.headers,
        body: jsonEncode(requestBody),
      ).timeout(FirebaseConfig.requestTimeout);
      
      if (FirebaseConfig.enableDebugMode) {
        print('User profile updated: $displayName');
      }
    } catch (e) {
      if (FirebaseConfig.enableDebugMode) {
        print('Failed to update user profile: $e');
      }
    }
  }

  // Refrescar token de Firebase
  Future<bool> refreshToken() async {
    if (_currentRefreshToken == null) return false;
    
    try {
      final requestBody = {
        'grant_type': 'refresh_token',
        'refresh_token': _currentRefreshToken,
      };

      final response = await http.post(
        Uri.parse(FirebaseConfig.refreshTokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: requestBody.entries.map((e) => '${e.key}=${e.value}').join('&'),
      ).timeout(FirebaseConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _currentIdToken = responseData['id_token'];
        _currentRefreshToken = responseData['refresh_token'];
        
        if (FirebaseConfig.enableDebugMode) {
          print('Token refreshed successfully');
        }
        
        return true;
      }
    } catch (e) {
      if (FirebaseConfig.enableDebugMode) {
        print('Failed to refresh token: $e');
      }
    }
    
    return false;
  }

  // Método de logout
  Future<void> logout() async {
    try {
      if (FirebaseConfig.enableDebugMode) {
        print('Starting logout process...');
      }

      // Limpiar tokens almacenados
      _currentIdToken = null;
      _currentRefreshToken = null;
      
      // Limpiar usuario actual
      _currentUser = null;
      
      // Actualizar streams
      _userController.add(null);
      _setStatus(AuthStatus.unauthenticated);
      
      if (FirebaseConfig.enableDebugMode) {
        print('Logout completed successfully');
      }
      
    } catch (e) {
      if (FirebaseConfig.enableDebugMode) {
        print('Error during logout: $e');
      }
      // No re-lanzar el error, logout local siempre debe funcionar
    }
  }

  // Método privado para cambiar estado
  void _setStatus(AuthStatus status) {
    _currentStatus = status;
    _authStatusController.add(status);
  }

  // Cleanup
  void dispose() {
    _authStatusController.close();
    _userController.close();
  }
}