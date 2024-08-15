// app/view/screens/help_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:doctor_skin/app/view/widgets/NavBar.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
                'Aide et Assistance',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 19, 145),
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
          Padding(
            padding: const EdgeInsets.only(top: 140), // Start below the title
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Card(
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
                      child: Text(
                        'Voici quelques conseils pour vous aider à tirer le meilleur parti de Doctor Skin:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1. Assurez-vous d\'avoir une bonne éclairage:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Pour de meilleurs résultats, prenez des photos dans un endroit bien éclairé pour permettre à l\'application d\'analyser correctement votre peau.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '2. Suivez les directives pour le téléchargement des images:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Utilisez des images claires et nettes où la condition de la peau est visible sans obstructions.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '3. Mises à jour régulières:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Gardez l\'application à jour pour utiliser les dernières fonctionnalités et améliorations en matière de technologie d\'analyse de la peau.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 100,
                child: CustomBottomNavBar(
                  currentIndex: 3,
                  onChange: (index) {
                    Navigator.pushNamed(context, '/home'); // Example redirect
                  },
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
