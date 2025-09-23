import 'package:flutter/material.dart';

import 'package:eqx/widgats/background.dart';
import 'package:eqx/widgats/card_table_responsive.dart';
import 'package:eqx/widgats/custom_bottom_navigation.dart';
import 'package:eqx/widgats/page_title.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Background(),
          // Home Body
          _HomeBody()
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
   );
  }
}

class _HomeBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        // Titulos (fijo, siempre visible)
        PageTitle(),

        // Card Table (con scroll)
        Expanded(
          child: SingleChildScrollView(
            child: CardTableResponsive(),
          ),
        ),
      
      ],
    );
  }
}