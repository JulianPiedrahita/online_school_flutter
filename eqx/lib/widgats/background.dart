import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Background extends StatelessWidget {

  final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2, 0.8],
        colors: [
          Color(0xff1B4332),
          Color(0xff40916C)
        ]
      )
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Green Gradinet
        Container(decoration: boxDecoration ),

        // White box
        Positioned(
          top: -100,
          left: -30,
          child: _WhiteBox()
        ),
      ],
    );
  }
}


class _WhiteBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // Detectar si estamos en web para ajustar tamaño
    final bool isWeb = kIsWeb;
    final screenSize = MediaQuery.of(context).size;
    
    // Breakpoints responsive para web
    final bool isSmallWeb = isWeb && screenSize.width < 768;
    final bool isMediumWeb = isWeb && screenSize.width >= 768 && screenSize.width < 1200;
    final bool isLargeWeb = isWeb && screenSize.width >= 1200;
    
    // Tamaños y posiciones responsive
    double getBoxSize() {
      if (!isWeb) return 360;
      if (isSmallWeb) return screenSize.width * 0.8;
      if (isMediumWeb) return screenSize.width * 0.7;
      return screenSize.width * 0.6;
    }
    
    double getBorderRadius() {
      if (!isWeb) return 80;
      if (isSmallWeb) return 60;
      if (isMediumWeb) return 100;
      return 120;
    }
    
    final double boxSize = getBoxSize();
    final double borderRadius = getBorderRadius();
    
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 255, 255, 0.1),
              Color.fromRGBO(245, 245, 245, 0.05),
            ]
          )
        ),
      ),
    );
  }
}