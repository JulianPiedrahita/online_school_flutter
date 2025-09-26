import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:eqx/widgets/background.dart';
import 'package:eqx/controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          _RegisterBody(authController: _authController),
        ],
      ),
    );
  }
}

class _RegisterBody extends StatelessWidget {
  final AuthController authController;

  const _RegisterBody({required this.authController});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final screenSize = MediaQuery.of(context).size;
    
    // Breakpoints responsive para web
    final bool isSmallWeb = isWeb && screenSize.width < 768;
    final bool isMediumWeb = isWeb && screenSize.width >= 768 && screenSize.width < 1200;
    final bool isLargeWeb = isWeb && screenSize.width >= 1200;
    
    // Función para obtener dimensiones responsive
    double getResponsiveValue(double mobile, double smallWeb, double mediumWeb, double largeWeb) {
      if (!isWeb) return mobile;
      if (isSmallWeb) return smallWeb;
      if (isMediumWeb) return mediumWeb;
      return largeWeb;
    }
    
    return Column(
      children: [
        // Título fijo en la parte superior
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: getResponsiveValue(60, 40, 60, 80),
            bottom: getResponsiveValue(20, 15, 20, 25)
          ),
          child: Column(
            children: [
              Text(
                'EQX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveValue(50, 55, 65, 75),
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Text(
                'Crear Cuenta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveValue(20, 22, 24, 26),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        
        // Formulario con scroll
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: isWeb ? getResponsiveValue(400, 400, 500, 600) : double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveValue(20, 40, 60, 80),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: getResponsiveValue(20, 15, 20, 25)),
                    
                    // Formulario
                    _RegisterForm(authController: authController),
                    
                    SizedBox(height: getResponsiveValue(30, 50, 70, 90)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final AuthController authController;

  const _RegisterForm({required this.authController});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final screenSize = MediaQuery.of(context).size;
    
    // Breakpoints responsive para web
    final bool isSmallWeb = isWeb && screenSize.width < 768;
    final bool isMediumWeb = isWeb && screenSize.width >= 768 && screenSize.width < 1200;
    final bool isLargeWeb = isWeb && screenSize.width >= 1200;
    
    // Función para obtener dimensiones responsive
    double getResponsiveValue(double mobile, double smallWeb, double mediumWeb, double largeWeb) {
      if (!isWeb) return mobile;
      if (isSmallWeb) return smallWeb;
      if (isMediumWeb) return mediumWeb;
      return largeWeb;
    }

    return AnimatedBuilder(
      animation: authController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.all(getResponsiveValue(20, 15, 20, 25)),
          padding: EdgeInsets.all(getResponsiveValue(30, 25, 35, 40)),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.15),
            borderRadius: BorderRadius.circular(getResponsiveValue(20, 18, 22, 25)),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Form(
            key: authController.registerFormKey,
            child: Column(
              children: [
                // Campo Nombre
                _buildTextFormField(
                  controller: authController.firstNameController,
                  labelText: 'Nombre',
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.givenName],
                  validator: (value) => authController.validateRequired(value, 'nombre'),
                  enabled: !authController.isLoading,
                  getResponsiveValue: getResponsiveValue,
                ),
                
                SizedBox(height: getResponsiveValue(18, 16, 20, 22)),
                
                // Campo Apellido
                _buildTextFormField(
                  controller: authController.lastNameController,
                  labelText: 'Apellido',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.familyName],
                  validator: (value) => authController.validateRequired(value, 'apellido'),
                  enabled: !authController.isLoading,
                  getResponsiveValue: getResponsiveValue,
                ),
                
                SizedBox(height: getResponsiveValue(18, 16, 20, 22)),
                
                // Campo Email
                _buildTextFormField(
                  controller: authController.emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.email],
                  validator: authController.validateEmail,
                  enabled: !authController.isLoading,
                  getResponsiveValue: getResponsiveValue,
                ),
                
                SizedBox(height: getResponsiveValue(18, 16, 20, 22)),
                
                // Campo Teléfono
                _buildTextFormField(
                  controller: authController.phoneController,
                  labelText: 'Teléfono',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.telephoneNumber],
                  validator: authController.validatePhone,
                  enabled: !authController.isLoading,
                  getResponsiveValue: getResponsiveValue,
                ),
                
                SizedBox(height: getResponsiveValue(18, 16, 20, 22)),
                
                // Campo Ciudad
                _buildTextFormField(
                  controller: authController.cityController,
                  labelText: 'Ciudad',
                  icon: Icons.location_city,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.addressCity],
                  validator: (value) => authController.validateRequired(value, 'ciudad'),
                  enabled: !authController.isLoading,
                  getResponsiveValue: getResponsiveValue,
                ),
                
                SizedBox(height: getResponsiveValue(18, 16, 20, 22)),
                
                // Campo Dirección
                _buildTextFormField(
                  controller: authController.addressController,
                  labelText: 'Dirección',
                  icon: Icons.home,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.fullStreetAddress],
                  validator: (value) => authController.validateRequired(value, 'dirección'),
                  enabled: !authController.isLoading,
                  getResponsiveValue: getResponsiveValue,
                ),
                
                SizedBox(height: getResponsiveValue(18, 16, 20, 22)),
                
                // Campo Contraseña
                _buildPasswordField(
                  controller: authController.passwordController,
                  labelText: 'Contraseña',
                  isVisible: authController.isPasswordVisible,
                  onToggleVisibility: authController.togglePasswordVisibility,
                  textInputAction: TextInputAction.next,
                  validator: authController.validateStrongPassword,
                  enabled: !authController.isLoading,
                  getResponsiveValue: getResponsiveValue,
                ),
                
                SizedBox(height: getResponsiveValue(18, 16, 20, 22)),
                
                // Campo Confirmar Contraseña
                _buildPasswordField(
                  controller: authController.confirmPasswordController,
                  labelText: 'Confirmar Contraseña',
                  isVisible: authController.isConfirmPasswordVisible,
                  onToggleVisibility: authController.toggleConfirmPasswordVisibility,
                  textInputAction: TextInputAction.done,
                  validator: authController.validateConfirmPassword,
                  enabled: !authController.isLoading,
                  getResponsiveValue: getResponsiveValue,
                  onFieldSubmitted: (_) => _handleRegister(context),
                ),
                
                SizedBox(height: getResponsiveValue(30, 25, 35, 40)),
                
                // Botón Crear Cuenta
                SizedBox(
                  width: double.infinity,
                  height: getResponsiveValue(50, 45, 55, 60),
                  child: ElevatedButton(
                    onPressed: authController.isLoading ? null : () => _handleRegister(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(getResponsiveValue(15, 12, 15, 18)),
                        side: BorderSide(color: Colors.white.withOpacity(0.5), width: 2),
                      ),
                      elevation: 0,
                    ),
                    child: authController.isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Crear Cuenta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getResponsiveValue(18, 16, 20, 22),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                SizedBox(height: getResponsiveValue(15, 13, 18, 20)),
                
                // Link para ir al login
                TextButton(
                  onPressed: authController.isLoading ? null : () {
                    Navigator.pushReplacementNamed(context, 'login_screen');
                  },
                  child: Text(
                    '¿Ya tienes cuenta? Iniciar Sesión',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: getResponsiveValue(10, 12, 15, 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    required List<String> autofillHints,
    required String? Function(String?) validator,
    required bool enabled,
    required double Function(double, double, double, double) getResponsiveValue,
    Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.white70,
          fontSize: getResponsiveValue(14, 15, 16, 17),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
          size: getResponsiveValue(20, 22, 24, 26),
        ),
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getResponsiveValue(15, 12, 15, 18)),
          borderSide: BorderSide(color: Colors.white30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getResponsiveValue(15, 12, 15, 18)),
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getResponsiveValue(15, 12, 15, 18)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: getResponsiveValue(16, 18, 20, 22),
          horizontal: 12,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: getResponsiveValue(14, 15, 16, 17),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required TextInputAction textInputAction,
    required String? Function(String?) validator,
    required bool enabled,
    required double Function(double, double, double, double) getResponsiveValue,
    Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      autofillHints: [AutofillHints.password],
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.white70,
          fontSize: getResponsiveValue(14, 15, 16, 17),
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.white70,
          size: getResponsiveValue(20, 22, 24, 26),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
            size: getResponsiveValue(20, 22, 24, 26),
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getResponsiveValue(15, 12, 15, 18)),
          borderSide: BorderSide(color: Colors.white30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getResponsiveValue(15, 12, 15, 18)),
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getResponsiveValue(15, 12, 15, 18)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: getResponsiveValue(16, 18, 20, 22),
          horizontal: 12,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: getResponsiveValue(14, 15, 16, 17),
      ),
      validator: validator,
    );
  }

  Future<void> _handleRegister(BuildContext context) async {
    final success = await authController.register(context);
    if (success) {
      // Después del registro exitoso, ir directamente al home ya que el usuario queda logueado
      Navigator.pushReplacementNamed(context, 'home_screen');
    }
  }
}