import 'package:firebase_core/firebase_core.dart';  // Import nécessaire pour initialiser Firebase
import 'package:fityes/principal_dash.dart';
import 'package:fityes/sprint_1/profilepage.dart';
import 'package:fityes/sprint_2/admin_dashboard_sprint2.dart';
import 'package:fityes/sprint_1/LoginPage.dart';
import 'package:fityes/sprint_1/account.dart';
import 'package:fityes/sprint_2/Breakfast/breakfast_interface.dart';
import 'package:fityes/sprint_2/Breakfast/food_info_detail_popular.dart';
import 'package:fityes/home.dart';  // Assurez-vous que Home est bien importé
import 'package:fityes/sprint_2/admin_service.dart';
import 'package:fityes/sprint_2/mealPlanner.dart';
import 'package:fityes/sprint_3/workout_planner.dart';
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
      home: WorkoutTrackerView() ,  
    
      // Redirige vers la page Home
    );
  }
}
