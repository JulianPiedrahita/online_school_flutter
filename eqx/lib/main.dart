import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eqx/screens/home_screen.dart';
import 'package:eqx/screens/login_screen.dart';
import 'package:eqx/screens/register_screen.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle.light );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData.dark(),
      initialRoute: 'login_screen',
      routes: {
    
        'login_screen' : ( _ ) => LoginScreen(),
        'register_screen' : ( _ ) => RegisterScreen(),
        'home_screen'  : ( _ ) => HomeScreen(), 
      },
    );
  }
}