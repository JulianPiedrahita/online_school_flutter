import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    double getResponsiveValue(double mobile, double tablet, double desktop, double ultraWide) {
      if (screenWidth >= 1440) return ultraWide;
      if (screenWidth >= 1200) return desktop;
      if (screenWidth >= 768) return tablet;
      return mobile;
    }
    return Container(
      margin: EdgeInsets.all(getResponsiveValue(16, 24, 32, 48)),
      padding: EdgeInsets.all(getResponsiveValue(16, 24, 32, 48)),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(getResponsiveValue(10, 14, 20, 28)),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: getResponsiveValue(8, 12, 20, 28),
            offset: Offset(0, getResponsiveValue(2, 4, 8, 12)),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: getResponsiveValue(18, 20, 24, 32),
                  height: getResponsiveValue(18, 20, 24, 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getResponsiveValue(3, 4, 6, 8)),
                    image: DecorationImage(
                      image: AssetImage('assets/logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: getResponsiveValue(4, 6, 8, 12)),
                Text(
                  'EQX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getResponsiveValue(14, 16, 20, 28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: getResponsiveValue(8, 12, 16, 24)),
            Text(
              '© 2025 EQX - Ministerio de Evangelización. Todos los derechos reservados.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: getResponsiveValue(10, 12, 14, 18),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}