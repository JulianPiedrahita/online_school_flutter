
import 'package:flutter/material.dart';
import 'package:eqx/widgets/background.dart';
import 'package:eqx/widgets/sticky_navigation_menu.dart';
import 'package:eqx/widgets/footer.dart';

class ServicioComunidadScreen extends StatefulWidget {
  @override
  _ServicioComunidadScreenState createState() => _ServicioComunidadScreenState();
}

class _ServicioComunidadScreenState extends State<ServicioComunidadScreen> {
    final List<String> spainImages = [
      'assets/community_service/spain/7e3a0546-bea4-4ff9-8763-2f409bf0150d.jpeg',
      'assets/community_service/spain/IMG_4879.jpeg',
      'assets/community_service/spain/IMG_5555.jpeg',
      'assets/community_service/spain/IMG_5558.jpeg',
    ];
    int currentSpain = 0;
  final List<String> armeniaImages = [
    'assets/community_service/armenia/IMG_5996.jpeg',
    'assets/community_service/armenia/IMG_5997.jpeg',
    'assets/community_service/armenia/IMG_6070.jpeg',
    'assets/community_service/armenia/IMG_6076.jpeg',
  ];
  int currentArmenia = 0;

  final List<String> sevillaImages = [
    'assets/community_service/sevilla/2e4914ec-51dd-4f11-9527-1843d0282203.jpeg',
    'assets/community_service/sevilla/622a56e4-2a7a-477e-8f07-649cb3e5ab36.jpeg',
    'assets/community_service/sevilla/IMG_5823.jpeg',
    'assets/community_service/sevilla/IMG_5826.jpeg',
    'assets/community_service/sevilla/IMG_5828.jpeg',
  ];
  int currentSevilla = 0;

  void showArmeniaDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 16,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(armeniaImages[currentArmenia], fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSevillaDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 16,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(sevillaImages[currentSevilla], fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              StickyNavigationMenu(),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 24),
                        // Banner Armenia
                        Text(
                          'Servicio y Comunidad - Armenia',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 32),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: showArmeniaDialog,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  armeniaImages[currentArmenia],
                                  width: 600,
                                  height: 400,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 32),
                                onPressed: () {
                                  setState(() {
                                    currentArmenia = (currentArmenia - 1 + armeniaImages.length) % armeniaImages.length;
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 32),
                                onPressed: () {
                                  setState(() {
                                    currentArmenia = (currentArmenia + 1) % armeniaImages.length;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 48),
                        // Banner Sevilla
                        Text(
                          'Servicio y Comunidad - Sevilla',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 32),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: showSevillaDialog,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  sevillaImages[currentSevilla],
                                  width: 600,
                                  height: 400,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 32),
                                onPressed: () {
                                  setState(() {
                                    currentSevilla = (currentSevilla - 1 + sevillaImages.length) % sevillaImages.length;
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 32),
                                onPressed: () {
                                  setState(() {
                                    currentSevilla = (currentSevilla + 1) % sevillaImages.length;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 48),
                        // Banner Spain
                        Text(
                          'Servicio y Comunidad - Spain',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 32),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(24),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 16,
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(24),
                                            child: Image.asset(spainImages[currentSpain], fit: BoxFit.contain),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  spainImages[currentSpain],
                                  width: 600,
                                  height: 400,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 32),
                                onPressed: () {
                                  setState(() {
                                    currentSpain = (currentSpain - 1 + spainImages.length) % spainImages.length;
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 32),
                                onPressed: () {
                                  setState(() {
                                    currentSpain = (currentSpain + 1) % spainImages.length;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 48),
                        Footer(),
                      ],
                    ),
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
