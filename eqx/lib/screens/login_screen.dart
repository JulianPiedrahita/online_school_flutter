import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:eqx/widgets/background.dart';
import 'package:eqx/widgets/social_login_widgets.dart';
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
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar si es una pantalla pequeña basado en la altura disponible
        final isSmallScreen = constraints.maxHeight < 700;
        final isVerySmallScreen = constraints.maxHeight < 600;
        
        return Center(
          child: Container(
            width: isWeb ? getResponsiveValue(400, 400, 500, 600) : double.infinity,
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.95, // Usar máximo 95% de altura disponible
            ),
            padding: EdgeInsets.symmetric(
              horizontal: getResponsiveValue(20, 40, 60, 80),
              vertical: getResponsiveValue(
                isVerySmallScreen ? 5 : (isSmallScreen ? 8 : 15), 
                20, 30, 40
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: getResponsiveValue(
                isVerySmallScreen ? 5 : (isSmallScreen ? 10 : (isWeb ? 15 : 20)),
                30, 40, 50
              )),
              
              // Título
              Text(
                'EQX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveValue(
                    isVerySmallScreen ? 35 : (isSmallScreen ? 40 : 50),
                    55, 65, 75
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: getResponsiveValue(
                isVerySmallScreen ? 5 : (isSmallScreen ? 8 : 10),
                10, 12, 15
              )),
              
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveValue(
                    isVerySmallScreen ? 14 : (isSmallScreen ? 16 : 20),
                    22, 24, 26
                  ),
                  fontWeight: FontWeight.w300,
                ),
              ),
              
              SizedBox(height: getResponsiveValue(
                isVerySmallScreen ? 8 : (isSmallScreen ? 12 : (isWeb ? 18 : 20)),
                25, 30, 35
              )),
              
              // Formulario
              _LoginForm(authController: authController),
            ],
          ),
        ),
      );
      },
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
    
    // Detectar pantallas pequeñas por altura disponible
    final isSmallScreen = screenSize.height < 700;
    final isVerySmallScreen = screenSize.height < 600;
    
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
          margin: EdgeInsets.all(getResponsiveValue(
            isVerySmallScreen ? 4 : (isSmallScreen ? 8 : 12),
            10, 15, 20
          )),
          padding: EdgeInsets.all(getResponsiveValue(
            isVerySmallScreen ? 10 : (isSmallScreen ? 15 : 20),
            20, 25, 30
          )),
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
                      vertical: getResponsiveValue(12, 14, 16, 18),
                      horizontal: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getResponsiveValue(14, 15, 16, 17),
                  ),
                  validator: authController.validateEmail,
                ),
                
                SizedBox(height: getResponsiveValue(
                  isVerySmallScreen ? 6 : (isSmallScreen ? 10 : 12),
                  15, 18, 20
                )),
                
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
                      vertical: getResponsiveValue(12, 14, 16, 18),
                      horizontal: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getResponsiveValue(14, 15, 16, 17),
                  ),
                  validator: authController.validatePassword,
                ),
                
                SizedBox(height: getResponsiveValue(
                  isVerySmallScreen ? 8 : (isSmallScreen ? 12 : 16),
                  20, 25, 30
                )),
                
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
                
                SizedBox(height: getResponsiveValue(12, 10, 14, 16)),
                
                // Enlace "¿Olvidaste tu contraseña?"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _showForgotPasswordDialog(context),
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: getResponsiveValue(14, 13, 15, 16),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: getResponsiveValue(8, 6, 10, 12)),
                
                // Separador "O"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'O',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: getResponsiveValue(14, 15, 16, 17),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: getResponsiveValue(12, 15, 18, 20)),
                
                // Botones de autenticación social (Google y Apple)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Botón de Google Sign-In
                    SocialLoginButton(
                      onPressed: authController.isLoading ? null : () => _handleGoogleLogin(context),
                      child: authController.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : _GoogleIcon(size: getResponsiveValue(28, 26, 30, 32)),
                      tooltip: 'Continuar con Google',
                    ),
                    
                    // Botón de Apple Sign-In
                    SocialLoginButton(
                      onPressed: authController.isLoading ? null : () => _handleAppleLogin(context),
                      child: AppleIcon(size: getResponsiveValue(28, 26, 30, 32)),
                      tooltip: 'Continuar con Apple',
                    ),
                  ],
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

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final success = await authController.loginWithGoogle(context);
    if (success) {
      Navigator.pushReplacementNamed(context, 'home_screen');
    }
  }

  Future<void> _handleAppleLogin(BuildContext context) async {
    // TODO: Implementar Apple Sign-In en futuras versiones
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apple Sign-In estará disponible próximamente'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff1B4332),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ingresa tu email y te enviaremos un enlace para restablecer tu contraseña.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  Navigator.of(context).pop();
                  await authController.sendPasswordResetEmail(context, email);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff40916C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Enviar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget personalizado para el ícono de Google
class _GoogleIcon extends StatelessWidget {
  final double size;
  
  const _GoogleIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFF4285F4), // Google Blue
            Color(0xFF34A853), // Google Green
            Color(0xFFFBBC05), // Google Yellow
            Color(0xFFEA4335), // Google Red
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}