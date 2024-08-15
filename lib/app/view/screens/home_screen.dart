// app/view/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:doctor_skin/app/view/widgets/NavBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'Doctor Skin',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 19,
                      145), // Even darker shade for better visibility
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                    ),
                  ],
                  fontFamily: 'Open Sans',
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/upload');
              },
              child: Center(
                child: Container(
                  width: 170.0,
                  height: 170.0,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logodr.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 280,
            left: 20,
            right: 20,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Color.fromARGB(255, 132, 212, 243)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // White for better contrast
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                          'Bienvenue sur Doctor Skin. Votre solution tout-en-un pour l\'analyse de la santé de la peau.'),
                      TyperAnimatedText(
                          'Bien que Doctor Skin utilise une technologie avancée pour analyser les images de la peau et fournir des évaluations, il est important de se rappeler que cet outil n\'est pas infaillible.'),
                      TyperAnimatedText(
                          'L\'exactitude du modèle peut ne pas atteindre 100 % et il ne remplace pas les conseils médicaux professionnels, le diagnostic ou le traitement.'),
                      TyperAnimatedText(
                          'Si vous avez des préoccupations ou si l\'application indique des problèmes de peau potentiels, nous vous conseillons vivement de consulter un dermatologue ou un prestataire de soins de santé pour un examen approfondi.'),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 100,
                child: CustomBottomNavBar(
                  currentIndex: _currentIndex,
                  onChange: _onItemTapped,
                  imagePaths: [
                    'assets/images/home_icon.png',
                    'assets/images/history_icon.png',
                    'assets/images/camera_icon.png',
                    'assets/images/help_icon.png',
                    'assets/images/profile_icon.png'
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
