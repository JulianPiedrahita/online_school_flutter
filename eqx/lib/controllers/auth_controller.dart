import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eqx/models/user_model.dart';
import 'package:eqx/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  StreamSubscription<User?>? _userStreamSubscription;
  
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Estados
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;
  User? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  AuthService get authService => _authService;

  // Constructor
  AuthController() {
    // Escuchar cambios en el servicio de autenticación
    _userStreamSubscription = _authService.userStream.listen((user) {
      _currentUser = user;
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  bool _disposed = false;

  // Alternar visibilidad de contraseña
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Validaciones
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$').hasMatch(value)) {
      return 'Debe incluir mayúscula, minúscula y número';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }
    if (value != passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu $fieldName';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu teléfono';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Ingresa un número de teléfono válido (10 dígitos)';
    }
    return null;
  }

  // Método de login
  Future<bool> login(BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) {
      return false;
    }

    _setLoading(true);
    clearError();

    try {
      final credentials = LoginCredentials(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final result = await _authService.login(credentials);

      if (result.success) {
        // Login exitoso
        _clearLoginForm();
        return true;
      } else {
        // Error en login
        _errorMessage = result.message ?? 'Error de autenticación';
        _showErrorSnackBar(context, _errorMessage!);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error inesperado: ${e.toString()}';
      _showErrorSnackBar(context, _errorMessage!);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Método de registro
  Future<bool> register(BuildContext context) async {
    if (!registerFormKey.currentState!.validate()) {
      return false;
    }

    _setLoading(true);
    clearError();

    try {
      final registerData = RegisterData(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
        address: addressController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      final result = await _authService.register(registerData);

      if (result.success) {
        // Registro exitoso
        _showSuccessSnackBar(context, '¡Cuenta creada exitosamente!');
        _clearRegisterForm();
        return true;
      } else {
        // Error en registro
        _errorMessage = result.message ?? 'Error al crear la cuenta';
        _showErrorSnackBar(context, _errorMessage!);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error inesperado: ${e.toString()}';
      _showErrorSnackBar(context, _errorMessage!);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Método de logout
  Future<void> logout() async {
    await _authService.logout();
    _clearAllForms();
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _clearLoginForm() {
    emailController.clear();
    passwordController.clear();
  }

  void _clearRegisterForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    cityController.clear();
    addressController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void _clearAllForms() {
    _clearLoginForm();
    _clearRegisterForm();
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _errorMessage = null;
  }

  @override
  void dispose() {
    _disposed = true;
    
    // Cancelar suscripción al stream
    _userStreamSubscription?.cancel();
    
    // Limpiar controllers
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    addressController.dispose();
    confirmPasswordController.dispose();
    
    super.dispose();
  }
}