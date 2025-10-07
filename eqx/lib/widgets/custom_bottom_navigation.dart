import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:eqx/screens/calendario_eventos_screen.dart';

class CustomBottomNavigation extends StatefulWidget {
  static Map<String, dynamic>? casaDePaz;
  
  static Map<DateTime, List<Map<String, dynamic>>> eventos = {};
  
  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int currentIndex = 0;
  // Variable global temporal para eventos
  
  
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
    
    final double iconSize = getResponsiveValue(24, 26, 28, 32);
    final double fontSize = getResponsiveValue(12, 13, 14, 16);
    final double borderRadius = getResponsiveValue(25, 20, 25, 30);
    final double containerHeight = getResponsiveValue(80, 75, 85, 90);
    
    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        color: Color.fromRGBO(27, 67, 50, 0.9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        child: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.transparent,
          unselectedItemColor: Color.fromRGBO(200, 200, 200, 0.8),
          currentIndex: currentIndex,
          selectedLabelStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: fontSize * 0.9,
            fontWeight: FontWeight.w400,
          ),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarioEventosScreen(eventos: CustomBottomNavigation.eventos),
                ),
              );
            } else if (index == 3) {
              Navigator.pushNamed(context, '/mapa');
            }
          },
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined, size: iconSize),
              activeIcon: Icon(Icons.calendar_today, size: iconSize * 1.1),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined, size: iconSize),
              activeIcon: Icon(Icons.message, size: iconSize * 1.1),
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_outlined, size: iconSize),
              activeIcon: Icon(Icons.radio, size: iconSize * 1.1),
              label: 'Radio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: iconSize),
              activeIcon: Icon(Icons.map, size: iconSize * 1.1),
              label: 'Mapa',
            ),
          ],
        ),
      ),
    );
  }
}