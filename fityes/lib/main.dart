import 'package:firebase_core/firebase_core.dart';  // Import nécessaire pour initialiser Firebase
import 'package:fityes/LoginPage.dart';
import 'package:fityes/sprint_1/account.dart';
import 'package:fityes/breakfast_interface.dart';
import 'package:fityes/food_info_detail_pancake.dart';
import 'package:fityes/home.dart';  // Assurez-vous que Home est bien importé
import 'package:fityes/mealPlanner.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Assure que Flutter est bien initialisé
  await Firebase.initializeApp();  // Initialisation de Firebase
  runApp(const MyApp());  // Lance l'application après initialisation de Firebase
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Home(),  // Redirige vers la page Home
    );
  }
}
