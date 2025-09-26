import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CardTableResponsive extends StatefulWidget {
  @override
  _CardTableResponsiveState createState() => _CardTableResponsiveState();
}

class _CardTableResponsiveState extends State<CardTableResponsive> {
  int selectedIndex = -1; // -1 significa que no hay ninguna seleccionada
  
  @override
  Widget build(BuildContext context) {
    
    // Detectar si estamos en web
    final bool isWeb = kIsWeb;
    final screenSize = MediaQuery.of(context).size;
    
    // Breakpoints responsive para web
    final bool isSmallWeb = isWeb && screenSize.width < 768;
    final bool isMediumWeb = isWeb && screenSize.width >= 768 && screenSize.width < 1200;
    final bool isLargeWeb = isWeb && screenSize.width >= 1200;
    
    // Determinar número de columnas basado en el tamaño de pantalla
    int getColumnCount() {
      if (!isWeb) return 2; // Móvil siempre 2 columnas
      if (isSmallWeb) return 2; // Web pequeña 2 columnas
      if (isMediumWeb) return 3; // Web mediana 3 columnas
      return 4; // Web grande 4 columnas
    }
    
    // Obtener margen responsive
    double getMargin() {
      if (!isWeb) return 20;
      if (isSmallWeb) return screenSize.width * 0.05;
      if (isMediumWeb) return screenSize.width * 0.08;
      return screenSize.width * 0.12;
    }
    
    final int columnCount = getColumnCount();
    final double margin = getMargin();
    
    // Lista de elementos para las tarjetas
    final cardItems = [
      {'color': Color(0xff1B4332), 'icon': Icons.school, 'text': 'Estudios'},
      {'color': Color(0xff1B4332), 'icon': Icons.home, 'text': 'Casas de paz'},
      {'color': Color(0xff1B4332), 'icon': Icons.event, 'text': 'Eventos'},
      {'color': Color(0xff1B4332), 'icon': Icons.library_books, 'text': 'Resources'},
      {'color': Color(0xff1B4332), 'icon': Icons.volunteer_activism, 'text': 'Ministerios'},
      {'color': Color(0xff1B4332), 'icon': Icons.music_note, 'text': 'Música'},
      {'color': Color(0xff1B4332), 'icon': Icons.people, 'text': 'Comunidad'},
      {'color': Color(0xff1B4332), 'icon': Icons.support, 'text': 'Apoyo'},
    ];
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: margin,
        vertical: 10
      ),
      child: isWeb && columnCount > 2 
        ? _buildGridLayout(cardItems, columnCount)
        : _buildTableLayout(cardItems),
    );
  }
  
  Widget _buildGridLayout(List<Map<String, dynamic>> items, int columnCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _SigleCard(
          color: item['color'],
          icon: item['icon'],
          text: item['text'],
          isSelected: selectedIndex == index,
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
        );
      },
    );
  }
  
  Widget _buildTableLayout(List<Map<String, dynamic>> items) {
    List<TableRow> rows = [];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        TableRow(
          children: [
            _SigleCard(
              color: items[i]['color'],
              icon: items[i]['icon'],
              text: items[i]['text'],
              isSelected: selectedIndex == i,
              onTap: () {
                setState(() {
                  selectedIndex = i;
                });
              },
            ),
            i + 1 < items.length
                ? _SigleCard(
                    color: items[i + 1]['color'],
                    icon: items[i + 1]['icon'],
                    text: items[i + 1]['text'],
                    isSelected: selectedIndex == (i + 1),
                    onTap: () {
                      setState(() {
                        selectedIndex = i + 1;
                      });
                    },
                  )
                : Container(), // Celda vacía si es impar
          ],
        ),
      );
    }
    
    return Table(children: rows);
  }
}


class _SigleCard extends StatelessWidget {

  final IconData icon;
  final Color color;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _SigleCard({
    Key? key,
    required this.icon,
    required this.color,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final screenSize = MediaQuery.of(context).size;
    
    // Breakpoints responsive
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
    
    final double iconSize = getResponsiveValue(35, 32, 38, 42);
    final double radius = getResponsiveValue(30, 28, 32, 36);
    final double fontSize = getResponsiveValue(18, 16, 18, 20);

    return GestureDetector(
      onTap: onTap,
      child: _CardBackground( 
        isSelected: isSelected,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? Colors.white : this.color,
              child: Icon( 
                this.icon, 
                size: iconSize, 
                color: isSelected ? this.color : Colors.white,
              ),
              radius: radius,
            ),
            SizedBox( height: 10 ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text( 
                this.text,
                textAlign: TextAlign.center,
                style: TextStyle( 
                  color: isSelected ? Colors.white : this.color, 
                  fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}


class _CardBackground extends StatelessWidget {

  final Widget child;
  final bool isSelected;

  const _CardBackground({
    Key? key, 
    required this.child,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final screenSize = MediaQuery.of(context).size;
    
    // Breakpoints responsive
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
    
    final double cardHeight = getResponsiveValue(180, 160, 180, 200);
    final double margin = getResponsiveValue(15, 8, 12, 15);
    final double borderRadius = getResponsiveValue(20, 16, 20, 24);
    
    return Container(
      margin: EdgeInsets.all(margin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur( sigmaX: 5, sigmaY: 5 ),
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: isSelected 
                ? Color.fromRGBO(255, 255, 255, 0.3)
                : Color.fromRGBO(255, 255, 255, 0.15),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isSelected 
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: this.child,
          ),
        ),
      ),
    );
  }
}