import 'package:flutter/material.dart';

class StickyNavigationMenu extends StatefulWidget {
  @override
  _StickyNavigationMenuState createState() => _StickyNavigationMenuState();
}

class _StickyNavigationMenuState extends State<StickyNavigationMenu> {
  String _selectedMenu = 'Inicio';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isVerySmallScreen = screenHeight < 600;
    final isSmallScreen = screenHeight < 700;
    final isMobileScreen = screenWidth < 768;
    double getResponsiveValue(double mobile, double tablet, double desktop) {
      if (screenWidth >= 1200) return desktop;
      if (screenWidth >= 768) return tablet;
      return mobile;
    }
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getResponsiveValue(10, 20, 20),
        vertical: getResponsiveValue(5, 8, 10)
      ),
      padding: EdgeInsets.symmetric(
        vertical: getResponsiveValue(
          isVerySmallScreen ? 8 : (isSmallScreen ? 12 : 15),
          18, 20
        ),
        horizontal: getResponsiveValue(15, 25, 30)
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, 'landing_page'),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getResponsiveValue(4, 6, 8),
                vertical: getResponsiveValue(2, 3, 4)
              ),
              child: Row(
                children: [
                  Container(
                    width: getResponsiveValue(
                      isVerySmallScreen ? 36 : (isSmallScreen ? 44 : 56),
                      64, 72
                    ),
                    height: getResponsiveValue(
                      isVerySmallScreen ? 36 : (isSmallScreen ? 44 : 56),
                      64, 72
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: AssetImage('assets/logo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: getResponsiveValue(4, 5, 6)),
                  Text(
                    'EQX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getResponsiveValue(
                        isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20),
                        22, 24
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          isMobileScreen 
            ? PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: Colors.white),
                onSelected: (value) {
                  if (value == 'Contáctenos') {
                    Navigator.pushNamed(context, 'contacto_screen');
                  } else if (value == 'Ministerio') {
                    Navigator.pushNamed(context, 'ministerio_screen');
                  } else if (value == 'Inicio') {
                    Navigator.pushNamed(context, 'landing_page');
                  } else {
                    setState(() {
                      _selectedMenu = value;
                    });
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'Inicio', child: Text('Inicio')),
                  PopupMenuItem(value: 'Ministerio', child: Text('Ministerio')),
                  PopupMenuItem(value: 'Contáctenos', child: Text('Contáctenos')),
                ],
              )
            : Row(
                children: [
                  _MenuButton(
                    title: 'Inicio',
                    isSelected: _selectedMenu == 'Inicio',
                    onPressed: () {
                      Navigator.pushNamed(context, 'landing_page');
                    },
                  ),
                  SizedBox(width: getResponsiveValue(15, 18, 20)),
                  _MenuButton(
                    title: 'Ministerio',
                    isSelected: _selectedMenu == 'Ministerio',
                    onPressed: () {
                      Navigator.pushNamed(context, 'ministerio_screen');
                    },
                  ),
                  SizedBox(width: getResponsiveValue(15, 18, 20)),
                  _MenuButton(
                    title: 'Servicio y Comunidad',
                    isSelected: _selectedMenu == 'Servicio y Comunidad',
                    onPressed: () {
                      Navigator.pushNamed(context, 'servicio_comunidad_screen');
                    },
                  ),
                  SizedBox(width: getResponsiveValue(15, 18, 20)),
                  _MenuButton(
                    title: 'Contáctenos',
                    isSelected: _selectedMenu == 'Contáctenos',
                    onPressed: () {
                      Navigator.pushNamed(context, 'contacto_screen');
                    },
                    isLoginButton: true,
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;
  final bool isLoginButton;

  const _MenuButton({
    required this.title,
    required this.isSelected,
    required this.onPressed,
    this.isLoginButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isLoginButton 
              ? Color.fromRGBO(255, 255, 255, 0.2)
              : (isSelected ? Color.fromRGBO(255, 255, 255, 0.1) : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
          border: isSelected && !isLoginButton
              ? Border.all(color: Colors.white.withOpacity(0.5), width: 1)
              : (isLoginButton ? Border.all(color: Colors.white.withOpacity(0.3), width: 1) : null),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isSelected || isLoginButton 
                ? FontWeight.w600 
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
