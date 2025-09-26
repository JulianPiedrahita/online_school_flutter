import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Widget personalizado para el ícono de Apple
class AppleIcon extends StatelessWidget {
  final double size;
  
  const AppleIcon({required this.size, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFF000000), // Negro Apple
            Color(0xFF333333), // Gris oscuro
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.apple,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }
}

// Widget personalizado para botones de autenticación social
class SocialLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String tooltip;
  
  const SocialLoginButton({
    required this.onPressed,
    required this.child,
    required this.tooltip,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final screenSize = MediaQuery.of(context).size;
    
    // Función para obtener dimensiones responsive
    double getResponsiveValue(double mobile, double smallWeb, double mediumWeb, double largeWeb) {
      if (!isWeb) return mobile;
      if (screenSize.width < 768) return smallWeb;
      if (screenSize.width < 1200) return mediumWeb;
      return largeWeb;
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        width: getResponsiveValue(60, 55, 65, 70),
        height: getResponsiveValue(60, 55, 65, 70),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(getResponsiveValue(30, 28, 32, 35)),
              side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: child,
        ),
      ),
    );
  }
}