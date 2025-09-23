import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:eqx/widgats/background.dart';
import 'package:eqx/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          _LoginBody(authController: _authController),
        ],
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  final AuthController authController;

  const _LoginBody({required this.authController});

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
    
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: isWeb ? getResponsiveValue(400, 400, 500, 600) : double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: getResponsiveValue(20, 40, 60, 80),
            vertical: getResponsiveValue(50, 80, 100, 120)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getResponsiveValue(80, 60, 80, 100)),
              
              // Título
              Text(
                'EQX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveValue(50, 55, 65, 75),
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveValue(20, 22, 24, 26),
                  fontWeight: FontWeight.w300,
                ),
              ),
              
              SizedBox(height: getResponsiveValue(50, 40, 50, 60)),
              
              // Formulario
              _LoginForm(authController: authController),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final AuthController authController;

  const _LoginForm({required this.authController});

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
            key: authController.loginFormKey,
            child: Column(
              children: [
                // Campo Email
                TextFormField(
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.email],
                  enabled: !authController.isLoading,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.white70,
                      fontSize: getResponsiveValue(14, 15, 16, 17),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
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
                  validator: authController.validateEmail,
                ),
                
                SizedBox(height: getResponsiveValue(20, 18, 22, 25)),
                
                // Campo Password
                TextFormField(
                  controller: authController.passwordController,
                  obscureText: !authController.isPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: [AutofillHints.password],
                  enabled: !authController.isLoading,
                  onFieldSubmitted: (_) => _handleLogin(context),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
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
                        authController.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                        size: getResponsiveValue(20, 22, 24, 26),
                      ),
                      onPressed: authController.togglePasswordVisibility,
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
                  validator: authController.validatePassword,
                ),
                
                SizedBox(height: getResponsiveValue(30, 25, 35, 40)),
                
                // Botón Login
                SizedBox(
                  width: double.infinity,
                  height: getResponsiveValue(50, 45, 55, 60),
                  child: ElevatedButton(
                    onPressed: authController.isLoading ? null : () => _handleLogin(context),
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
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getResponsiveValue(18, 16, 20, 22),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                SizedBox(height: getResponsiveValue(20, 18, 22, 25)),
                
                // Link para olvidé contraseña
                TextButton(
                  onPressed: authController.isLoading ? null : () {
                    // TODO: Implementar recuperación de contraseña
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: getResponsiveValue(12, 13, 15, 16),
                    ),
                  ),
                ),
                
                // Link para ir al registro
                TextButton(
                  onPressed: authController.isLoading ? null : () {
                    Navigator.pushReplacementNamed(context, 'register_screen');
                  },
                  child: Text(
                    '¿No tienes cuenta? Crear una',
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

  Future<void> _handleLogin(BuildContext context) async {
    final success = await authController.login(context);
    if (success) {
      Navigator.pushReplacementNamed(context, 'home_screen');
    }
  }
}