import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:eqx/screens/home_screen.dart';
import 'package:eqx/screens/login_screen.dart';
import 'package:eqx/screens/register_screen.dart';
import 'package:eqx/screens/landing_page.dart';
import 'package:eqx/screens/splash_screen.dart';
import 'package:eqx/screens/mapa_screen.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle.light );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EQX - Ministerio de Evangelización',
      theme: ThemeData.dark(),
      initialRoute: kIsWeb ? 'landing_page' : 'splash_screen',
      routes: {
        'splash_screen' : ( _ ) => SplashScreen(),
        'landing_page' : ( _ ) => LandingPage(),
        'login_screen' : ( _ ) => LoginScreen(),
        'register_screen' : ( _ ) => RegisterScreen(),
        'home_screen'  : ( _ ) => HomeScreen(),
        '/mapa': (_) => MapaScreen(),
      },
    );
  }
}