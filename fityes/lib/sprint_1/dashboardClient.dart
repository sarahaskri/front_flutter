import 'dart:convert';

import 'package:fityes/api_config.dart';
import 'package:fityes/home.dart';
import 'package:fityes/principal_dash.dart';
import 'package:fityes/sprint_1/LoginPage.dart';
import 'package:fityes/sprint_2/Breakfast/breakfast_interface.dart';
import 'package:fityes/sprint_2/mealPlanner.dart';
import 'package:fityes/sprint_3/workout_planner.dart';
import 'package:fityes/user_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboardclient extends StatefulWidget {
  final String goal;

  const Dashboardclient({Key? key, required this.goal}) : super(key: key);

  @override
  State<Dashboardclient> createState() => _Dashboardclient();
}

class _Dashboardclient extends State<Dashboardclient> {
  String? userId;
  int _selectedIndex = 0;



  Future<void> _loadUserId() async {
    await UserSession.loadUserId();
    setState(() {
      userId = UserSession.userIdN ?? UserSession.userIdF;
      print("userId dans dashboard client : $userId");
    });

    if (userId != null) {
      calculateGoal(userId!, widget.goal);
    } else {
      print("Erreur: userId est null");
    }
  }
  
    List<String> _titles = [
    'Home',
    'Meals',
    'Workouts',
    'Progression',
    'Profile',
  ];

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    print("Goal reçu : ${widget.goal}");
    _loadUserId();
    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        body: Center(
          child: Text('Dashboard Content Goes Here'),
        ),
      ),
    );
  }

  Future<void> calculateGoal(String userId, String goal) async {
    final baseUrl = ApiConfig.calculate_goal();
    print('userId: $userId, goal: $goal');
    final response = await http.post(
      baseUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'goal': goal}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('IMC: ${data['imc']}');
      print('Message: ${data['message']}');
      print('goal est :${data['goal']}');
    } else {
      print('Erreur: ${response.body}');
    }
  }
}
