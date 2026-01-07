import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:eqx/widgets/background.dart';
import 'package:eqx/widgets/sticky_navigation_menu.dart';
import 'package:eqx/widgets/footer.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              // Banner fijo eliminado
              
              // Menú fijo
              StickyNavigationMenu(),
              
              // Contenido scrolleable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Espaciado para compensar el banner y menú fijos
                      SizedBox(height: 20),
                      
                      // Sección 1
                      // Solo se deja la sección de Misión y Visión, eliminando el banner y Comunidad y Servicio
                      _ContentSectionWithBanner(
                        title: 'Nuestra Misión',
                        content: '''Equipar para Multiplicar es un ministerio internacional que existe para entrenar y acompañar a discípulos de Jesús, ayudándolos a vivir una fe que se reproduce. Caminamos junto a la iglesia local para formar discípulos que hacen más discípulos y, como fruto de esa multiplicación, participan en la plantación de nuevas iglesias para la expansión del Reino de Dios.''',
                        bannerImages: [
                          'assets/banners_secciones_1/boquia.jpeg',
                          'assets/banners_secciones_1/central.jpeg',
                        ],
                        isImageLeft: true,
                      ),
                      _ContentSectionWithBanner(
                        title: 'Nuestra Visión',
                        content: '''Anhelamos ver un movimiento creciente de discípulos que hacen discípulos, iglesias que plantan iglesias y comunidades transformadas por el poder del Evangelio, en cada nación y cultura, para la gloria de Jesucristo.''',
                        bannerImages: [
                          'assets/banners_secciones_2/pinares.jpeg',
                          'assets/banners_secciones_2/salon_central.jpeg',
                        ],
                        isImageLeft: false,
                      ),
                      
                      // Footer
                      Footer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _ContentSectionWithBanner extends StatefulWidget {
  final String title;
  final String content;
  final List<String> bannerImages;
  final bool isImageLeft;

  const _ContentSectionWithBanner({
    required this.title,
    required this.content,
    required this.bannerImages,
    required this.isImageLeft,
  });

  @override
  __ContentSectionWithBannerState createState() => __ContentSectionWithBannerState();
}

class __ContentSectionWithBannerState extends State<_ContentSectionWithBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Auto-scroll del banner cada 3 segundos
    Future.delayed(Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (mounted && widget.bannerImages.isNotEmpty) {
      setState(() {
        _currentPage = (_currentPage + 1) % widget.bannerImages.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      Future.delayed(Duration(seconds: 4), _autoScroll);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Detección completa de tipos de pantalla
    final isVerySmallScreen = screenHeight < 600;
    final isSmallScreen = screenHeight < 700;
    final isMobileScreen = screenWidth < 768;
    final isTabletScreen = screenWidth >= 768 && screenWidth < 1200;
    final isDesktopScreen = screenWidth >= 1200;
    final isUltraWideScreen = screenWidth >= 1440;
    
    // Función para obtener valores responsive universales
    double getResponsiveValue(double mobile, double tablet, double desktop, double ultraWide) {
      if (isUltraWideScreen) return ultraWide;
      if (isDesktopScreen) return desktop;
      if (isTabletScreen) return tablet;
      return mobile;
    }

    Widget bannerWidget = Container(
      width: isMobileScreen ? double.infinity : getResponsiveValue(350, 400, 450, 500),
      child: AspectRatio(
        aspectRatio: isMobileScreen ? 16/9 : 4/3,
        child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.bannerImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.bannerImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Overlay con gradiente
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Controles de navegación
          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  final prevPage = (_currentPage - 1 + widget.bannerImages.length) % widget.bannerImages.length;
                  setState(() {
                    _currentPage = prevPage;
                  });
                  _pageController.animateToPage(
                    prevPage,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 32,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  final nextPage = (_currentPage + 1) % widget.bannerImages.length;
                  setState(() {
                    _currentPage = nextPage;
                  });
                  _pageController.animateToPage(
                    nextPage,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 32,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          
          // Indicadores de página
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.bannerImages.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == index ? 10 : 6,
                  height: _currentPage == index ? 10 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
        ),
    );

    Widget textWidget = Container(
      width: isMobileScreen ? double.infinity : getResponsiveValue(400, 500, 600, 700),
      padding: EdgeInsets.all(getResponsiveValue(
        isVerySmallScreen ? 15 : (isSmallScreen ? 20 : 30),
        25, 35, 40
      )),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.15),
        borderRadius: BorderRadius.circular(getResponsiveValue(15, 18, 20, 22)),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: getResponsiveValue(
                isVerySmallScreen ? 20 : (isSmallScreen ? 24 : 28),
                32, 36, 40
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: getResponsiveValue(12, 16, 20, 24)),
          Text(
            widget.content,
            style: TextStyle(
              color: Colors.white70,
              fontSize: getResponsiveValue(
                isVerySmallScreen ? 12 : (isSmallScreen ? 14 : 16),
                16, 18, 20
              ),
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getResponsiveValue(40, 60, 80, 100),
        horizontal: getResponsiveValue(20, 30, 40, 60)
      ),
      child: isMobileScreen
          ? Column(
              children: [
                bannerWidget,
                SizedBox(height: getResponsiveValue(20, 30, 40, 50)),
                textWidget,
              ],
            )
          : IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.isImageLeft
                  ? [
                      bannerWidget,
                      SizedBox(width: getResponsiveValue(30, 40, 60, 80)),
                      textWidget,
                    ]
                  : [
                      textWidget,
                      SizedBox(width: getResponsiveValue(30, 40, 60, 80)),
                      bannerWidget,
                    ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    // Responsive helpers
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