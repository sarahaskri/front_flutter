import 'dart:convert';

import 'package:fityes/api_config.dart';
import 'package:fityes/home.dart';
import 'package:fityes/principal_dash.dart';
import 'package:fityes/sprint_1/LoginPage.dart';
import 'package:fityes/sprint_1/dashboardClient.dart';
import 'package:fityes/sprint_2/Breakfast/breakfast_interface.dart';
import 'package:fityes/sprint_2/mealPlanner.dart';
import 'package:fityes/sprint_3/workout_planner.dart';
import 'package:fityes/user_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardHome extends StatefulWidget {
  final String goal;

  const DashboardHome({Key? key, required this.goal}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHome();
}

class _DashboardHome extends State<DashboardHome> {
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
    _screens = [
      Dashboardclient(goal: widget.goal),
      MealPlannerPage(),
      WorkoutTrackerView(),
      Home(),
      LoginPage(),
    ];
  }
 
 void _onTappedItem (int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: _onTappedItem,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home", backgroundColor: Color(0xFF7EB6FF),
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: "Meals",
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: "Workouts",
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: "Progression",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
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
    } else {
      print('Erreur: ${response.body}');
    }
  }
}
