import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eqx/widgets/background.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              // Banner fijo
              _StickyBannerSection(),
              
              // Menú fijo
              _StickyNavigationMenu(),
              
              // Contenido scrolleable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Espaciado para compensar el banner y menú fijos
                      SizedBox(height: 20),
                      
                      // Secciones de contenido
                      _ContentSections(),
                      
                      // Footer
                      _Footer(),
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

class _StickyBannerSection extends StatefulWidget {
  @override
  __StickyBannerSectionState createState() => __StickyBannerSectionState();
}

class __StickyBannerSectionState extends State<_StickyBannerSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> bannerImages = [
    'assets/banner_principal/banner.jpg',
    'assets/banner_principal/cirdulos.jpg',
    'assets/banner_principal/escudo.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll continuo del banner
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (mounted && _pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= bannerImages.length * 1000) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
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
    
    // Función para obtener valores responsive
    double getResponsiveValue(double mobile, double tablet, double desktop) {
      if (screenWidth >= 1200) return desktop;
      if (screenWidth >= 768) return tablet;
      return mobile;
    }
    
    return Container(
      height: getResponsiveValue(
        isVerySmallScreen ? 220 : (isSmallScreen ? 250 : 280),
        320, 350
      ), // Altura reducida para mejor balance con el contenido
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: null, // Infinito
            onPageChanged: (index) {
              setState(() {
                _currentPage = index % bannerImages.length;
              });
            },
            itemBuilder: (context, index) {
              final imageIndex = index % bannerImages.length;
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(bannerImages[imageIndex]),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              );
            },
          ),
          
          // Indicadores de página
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                bannerImages.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyNavigationMenu extends StatefulWidget {
  @override
  __StickyNavigationMenuState createState() => __StickyNavigationMenuState();
}

class __StickyNavigationMenuState extends State<_StickyNavigationMenu> {
  String _selectedMenu = 'Inicio';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Detección completa de tipos de pantalla
    final isVerySmallScreen = screenHeight < 600;
    final isSmallScreen = screenHeight < 700;
    final isMobileScreen = screenWidth < 768;
    
    // Función para obtener valores responsive
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
          // Logo compacto
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
                      isVerySmallScreen ? 18 : (isSmallScreen ? 20 : 24),
                      26, 28
                    ),
                    height: getResponsiveValue(
                      isVerySmallScreen ? 18 : (isSmallScreen ? 20 : 24),
                      26, 28
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
          
          // Menú items compacto
          isMobileScreen 
            ? PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: Colors.white),
                onSelected: (value) {
                  if (value == 'Únete a Nosotros') {
                    Navigator.pushNamed(context, 'login_screen');
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
                  PopupMenuItem(value: 'Únete a Nosotros', child: Text('Únete a Nosotros')),
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
                      setState(() {
                        _selectedMenu = 'Ministerio';
                      });
                    },
                  ),
                  SizedBox(width: getResponsiveValue(15, 18, 20)),
                  _MenuButton(
                    title: 'Únete a Nosotros',
                    isSelected: _selectedMenu == 'Únete a Nosotros',
                    onPressed: () {
                      Navigator.pushNamed(context, 'login_screen');
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

class _ContentSections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primera sección
        _ContentSectionWithBanner(
          title: 'Nuestra Misión',
          content: '''Nuestra misión es llevar el mensaje de esperanza y salvación de Jesucristo a cada corazón. Creemos en el poder transformador del evangelio para cambiar vidas, restaurar familias y construir comunidades fuertes en la fe.

A través de la enseñanza bíblica sólida, el discipulado personal y el testimonio viviente, buscamos hacer discípulos que a su vez hagan discípulos, cumpliendo así la Gran Comisión que nuestro Señor nos dejó.''',
          bannerImages: [
            'assets/banners_secciones_1/boquia.jpeg',
            'assets/banners_secciones_1/central.jpeg',
          ],
          isImageLeft: true,
        ),
        
        // Segunda sección
        _ContentSectionWithBanner(
          title: 'Comunidad y Servicio',
          content: '''Somos una comunidad unida por el amor de Cristo, comprometida con servir a otros y compartir las buenas nuevas del evangelio. Creemos que cada persona tiene un propósito único en el plan de Dios y trabajamos juntos para edificar el Reino de los Cielos.

Nuestros ministerios abarcan desde la enseñanza bíblica hasta obras de caridad, siempre guiados por el Espíritu Santo y fundamentados en la Palabra de Dios, buscando glorificar a nuestro Padre celestial en todo lo que hacemos.''',
          bannerImages: [
            'assets/banners_secciones_2/pinares.jpeg',
            'assets/banners_secciones_2/salon_central.jpeg',
          ],
          isImageLeft: false,
        ),
      ],
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

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(40),
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 0.2),
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
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: AssetImage('assets/logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'EQX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              '© 2025 EQX - Ministerio de Evangelización. Todos los derechos reservados.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}