import 'dart:convert';

import 'package:fityes/api_config.dart';
import 'package:fityes/home.dart';
import 'package:fityes/sprint_2/Dinner/dinner_interface.dart';
import 'package:fityes/sprint_2/Lunch/lunch_interface.dart';
import 'package:fityes/user_session.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fityes/sprint_2/MealsItemsDropdown.dart'; // Assure-toi que ce chemin est correct
import 'package:fityes/sprint_2/Breakfast/breakfast_interface.dart';
import 'package:http/http.dart' as http;
import 'package:fityes/sprint_2/Todaymealdropdownstate.dart';
import '../user_session.dart';

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});

  @override
  _MealPlannerPageState createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  String selectedFrequency = "Weekly"; // Valeur initiale de la fréquence
  String selectedMealType = "Breakfast";
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    await UserSession.loadUserId();
    setState(() {
      userId = UserSession.userIdN ?? UserSession.userIdF;
      print("userId dans today meals: $userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Meal Planner"),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Nutritions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Meal Nutritions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF9fbef7),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MealNutritionsDropdown(
                      onValueChanged: (newValue) {
                        setState(() {
                          selectedFrequency = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              // Affichage de la fréquence sélectionnée
              //  Text(
              // "Selected Frequency: $selectedFrequency",
              //   style: const TextStyle(fontSize: 16),
              //   ),
              const SizedBox(height: 16),
              // Affichage des statistiques en fonction de la sélection
              _buildStatistics(),

              const SizedBox(height: 16),
              const SizedBox(height: 200, child: NutritionChart()),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today Meals",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF9fbef7),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Todaymealdropdownstate(
                      onValueChanged: (newValue) {
                        setState(() {
                          selectedMealType = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (userId != null)
                buildTodayMeals(selectedMealType, userId!)
              else
                const Center(child: CircularProgressIndicator()),

              ////   const MealTile(name: "Salmon Nigiri", time: "7am", image: "🍣"),
              /////   const MealTile(name: "Lowfat Milk", time: "8am", image: "🥞"),

              const SizedBox(height: 20),
              const Text("Find Something to Eat",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MealCategoryCard(
                      title: "Breakfast",
                      subtitle: "120+ Foods",
                      imagePath: "assets/images/apple_pie.png",
                    ),
                    SizedBox(width: 10),
                    MealCategoryCardPink(
                      title: "Lunch",
                      subtitle: "130+ Foods",
                      imagePath: "assets/images/lunch.png",
                    ),
                    SizedBox(width: 10),
                    MealCategoryCard(
                      title: "Dinner",
                      subtitle: "100+ Foods",
                      imagePath: "assets/images/dinner.png",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    // Affichage des statistiques selon la fréquence choisie
    if (selectedFrequency == "Daily") {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Text("Daily Statistics:"),
          // Affiche ici tes statistiques quotidiennes, par exemple :
          //Text("Calories consumed: 1500"),
          // Text("Meals: 3"),
          // Autres statistiques
        ],
      );
    } else if (selectedFrequency == "Weekly") {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Text("Weekly Statistics:"),
          // Affiche ici tes statistiques hebdomadaires
          // Text("Calories consumed: 10500"),
          //    Text("Meals: 21"),
          // Autres statistiques
        ],
      );
    } else if (selectedFrequency == "Monthly") {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Text("Monthly Statistics:"),
          // Affiche ici tes statistiques mensuelles
          //Text("Calories consumed: 45000"),
          // Text("Meals: 90"),
          // Autres statistiques
        ],
      );
    } else {
      return const Text("No statistics available.");
    }
  }
}

class NutritionChart extends StatelessWidget {
  const NutritionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 60),
              FlSpot(1, 90),
              FlSpot(2, 40),
              FlSpot(3, 85),
              FlSpot(4, 60),
              FlSpot(5, 30),
              FlSpot(6, 70)
            ],
            isCurved: true,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          )
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchTodayMeals(
    String userId, String mealType) async {
  final baseUrl = ApiConfig.todayMeal();
  final response = await http.post(
    baseUrl,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "userId": userId,
      "mealType": mealType,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['meals']);
  } else {
    // Affiche seulement le contenu brut sans "Erreur" ou "Exception"
    print(response.body);
    return [];
  }
}

Widget buildTodayMeals(String mealType, String userId) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchTodayMeals(userId, mealType),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error : ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text("No  $mealType meals found for today");
      } else {
        final meals = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealType.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...meals.map((meal) {
              final name = meal['mealName'] ?? 'Name unknown';
              final time = meal['time'] ?? 'Time unknown';
              final imagePath = meal['imagePath'];

              return ListTile(
                leading: imagePath != null
                    ? Image.asset(
                        imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.fastfood),
                title: Text(name),
                subtitle: Text("Time: $time"),
              );
            }).toList(),
          ],
        );
      }
    },
  );
}

class MealCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const MealCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFe0eaff), Color(0xFFf7f8fc)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: 80,
          ),
          const SizedBox(height: 8),
          Text(
            title, // Correction ici
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle, // Correction ici
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7EB6FF), Color(0xFFB5AFFF)],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: TextButton(
              onPressed: () {
                // Navigation vers la page correspondante selon le mealType
                if (title == "Breakfast") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BreakfastPage()),
                  );
                } else if (title == "Lunch") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunchPage()),
                  );
                } else if (title == "Dinner") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DinnerPage()),
                  );
                }
              },
              child: const Text(
                "Select",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///cardmodel2
class MealCategoryCardPink extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const MealCategoryCardPink({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDDDE6), Color(0xFFD8B5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: 80,
          ),
          const SizedBox(height: 8),
          Text(
            title, // Correction ici
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle, // Correction ici
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 250, 156, 183),
                  Color(0xFFD8B5FF)
                ], // 🎨 Dégradé rose à violet clair
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                if (title == "Breakfast") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BreakfastPage()),
                  );
                } else if (title == "Lunch") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunchPage()),
                  );
                } else if (title == "Dinner") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DinnerPage()),
                  );
                }
              },
              child: const Text(
                "Select",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
