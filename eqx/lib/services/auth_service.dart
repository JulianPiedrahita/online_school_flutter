import 'dart:async';
import 'dart:convert';
import 'package:eqx/models/user_model.dart';

// Enums para manejar estados
enum AuthStatus { authenticated, unauthenticated, loading }

enum AuthError { 
  invalidCredentials, 
  emailAlreadyExists, 
  weakPassword, 
  networkError, 
  serverError,
  unknown 
}

// Clase de resultado para operaciones de autenticación
class AuthResult {
  final bool success;
  final User? user;
  final AuthError? error;
  final String? message;

  AuthResult({
    required this.success,
    this.user,
    this.error,
    this.message,
  });

  factory AuthResult.success(User user) {
    return AuthResult(
      success: true,
      user: user,
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

  AuthStatus get currentStatus => _currentStatus;
  User? get currentUser => _currentUser;

  // Simulación de base de datos en memoria
  final List<User> _registeredUsers = [];

  // Método de login
  Future<AuthResult> login(LoginCredentials credentials) async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Simular delay de red
      await Future.delayed(Duration(seconds: 2));
      
      // Validar formato de email
      if (!_isValidEmail(credentials.email)) {
        return AuthResult.failure(
          AuthError.invalidCredentials, 
          'Formato de email inválido'
        );
      }

      // Simular validación de credenciales
      // En una app real, esto sería una llamada a API
      final user = _registeredUsers.firstWhere(
        (user) => user.email == credentials.email,
        orElse: () => _createMockUser(credentials.email),
      );

      // Simular validación de contraseña
      if (credentials.password.length < 6) {
        return AuthResult.failure(
          AuthError.invalidCredentials,
          'Credenciales incorrectas'
        );
      }

      // Login exitoso
      _currentUser = user;
      _setStatus(AuthStatus.authenticated);
      _userController.add(_currentUser);

      return AuthResult.success(user);

    } catch (e) {
      _setStatus(AuthStatus.unauthenticated);
      return AuthResult.failure(
        AuthError.unknown,
        'Error inesperado: ${e.toString()}'
      );
    }
  }

  // Método de registro
  Future<AuthResult> register(RegisterData registerData) async {
    try {
      _setStatus(AuthStatus.loading);
      
      // Simular delay de red
      await Future.delayed(Duration(seconds: 3));

      // Validar si el email ya existe
      if (_registeredUsers.any((user) => user.email == registerData.email)) {
        return AuthResult.failure(
          AuthError.emailAlreadyExists,
          'Este email ya está registrado'
        );
      }

      // Validar datos
      if (!registerData.isValid) {
        return AuthResult.failure(
          AuthError.weakPassword,
          'Datos de registro inválidos'
        );
      }

      // Validar fortaleza de contraseña
      if (!_isStrongPassword(registerData.password)) {
        return AuthResult.failure(
          AuthError.weakPassword,
          'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número'
        );
      }

      // Crear nuevo usuario
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: registerData.firstName,
        lastName: registerData.lastName,
        email: registerData.email,
        phone: registerData.phone,
        city: registerData.city,
        address: registerData.address,
        createdAt: DateTime.now(),
      );

      // Agregar a la "base de datos"
      _registeredUsers.add(newUser);

      return AuthResult.success(newUser);

    } catch (e) {
      _setStatus(AuthStatus.unauthenticated);
      return AuthResult.failure(
        AuthError.unknown,
        'Error inesperado: ${e.toString()}'
      );
    }
  }

  // Método de logout
  Future<void> logout() async {
    _currentUser = null;
    _setStatus(AuthStatus.unauthenticated);
    _userController.add(null);
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

  // Crear usuario mock para testing
  User _createMockUser(String email) {
    return User(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      firstName: 'Usuario',
      lastName: 'Prueba',
      email: email,
      phone: '3001234567',
      city: 'Bogotá',
      address: 'Calle 123 #45-67',
      createdAt: DateTime.now(),
    );
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