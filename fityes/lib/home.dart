import 'package:fityes/account.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.white, // Arrière-plan blanc
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Texte placé légèrement plus haut que le centre
              Padding(
                padding:
                    const EdgeInsets.only(top: 150), // Ajustez la hauteur ici
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Texte avec style personnalisé
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                        children: [
                          TextSpan(
                            text: 'Energize',
                            style: TextStyle(color: Colors.black), // Texte noir
                          ),
                          TextSpan(
                            text: 'Me',
                            style: TextStyle(
                              color: Color.fromARGB(
                                  255, 139, 144, 244), // Texte bleu
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Everybody Can Train !',
                      style: TextStyle(
                        fontSize: 20,

                        color: Colors.grey, // Texte gris foncé
                      ),
                    ),
                  ],
                ),
              ),
              // Image entre le texte et le bouton
              Image.asset(
                'assets/images/home.png', // Remplacez par le chemin de votre image
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              // Bouton en bas
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 139, 144, 244),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white, // Texte du bouton blanc
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
