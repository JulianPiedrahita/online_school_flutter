import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PageTitle extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    
    // Detectar si estamos en web
    final bool isWeb = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Breakpoints responsive para web
    final bool isSmallWeb = isWeb && screenWidth < 600;
    final bool isMediumWeb = isWeb && screenWidth >= 600 && screenWidth < 1200;
    final bool isLargeWeb = isWeb && screenWidth >= 1200;
    
    // Cálculos responsive
    double getResponsiveFontSize(double mobile, double smallWeb, double mediumWeb, double largeWeb) {
      if (!isWeb) return mobile;
      if (isSmallWeb) return smallWeb;
      if (isMediumWeb) return mediumWeb;
      return largeWeb;
    }
    
    double getResponsiveMargin(double mobile, double webBase) {
      if (!isWeb) return mobile;
      return screenWidth * webBase; // Porcentaje del ancho de pantalla
    }
    
    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.only(
          top: isWeb ? 20 : 2, 
          left: isWeb ? 20 : 30, // Pequeño margen en web para no estar completamente pegado
          right: getResponsiveMargin(30, 0.1), // 10% del ancho en web, fijo en móvil
          bottom: 20
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EQX', 
              style: TextStyle( 
                color: Colors.white,
                fontSize: getResponsiveFontSize(30, 35, 45, 55), // Escalable según pantalla
                fontWeight: FontWeight.bold 
              )
            ),
            SizedBox(height: 5),
            Container(
              width: isWeb ? screenWidth * 0.6 : null, // 60% del ancho en web
              child: Text(
                'Discipulos que hacemos mas discipulos -  2 Tmoteo 2:2', 
                softWrap: true, // Permite que el texto se ajuste en múltiples líneas
                style: TextStyle( 
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(15, 14, 16, 18), // Escalable según pantalla
                  height: 1.3, // Espaciado entre líneas para mejor legibilidad
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}