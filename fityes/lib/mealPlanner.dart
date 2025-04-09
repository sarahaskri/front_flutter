import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fityes/MealsItemsDropdown.dart'; // Assure-toi que ce chemin est correct

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});

  @override
  _MealPlannerPageState createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  String selectedFrequency = "Weekly"; // Valeur initiale de la fréquence

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios),
                  Text("Meal Planner",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Icon(Icons.more_vert),
                ],
              ),
              const SizedBox(height: 20),

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

              const SizedBox(height: 16),
              // Affichage de la fréquence sélectionnée
              Text(
                "Selected Frequency: $selectedFrequency",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Affichage des statistiques en fonction de la sélection
              _buildStatistics(),

              const SizedBox(height: 16),
              const SizedBox(height: 200, child: NutritionChart()),

              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Daily Meal Schedule",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xFF9fbef7)),
                      ),
                      child:
                          Text("Check", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Today Meals",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: "Breakfast",
                    items: const [
                      DropdownMenuItem(
                          value: "Breakfast", child: Text("Breakfast"))
                    ],
                    onChanged: null,
                  )
                ],
              ),
              const SizedBox(height: 10),
              const MealTile(name: "Salmon Nigiri", time: "7am", image: "🍣"),
              const MealTile(name: "Lowfat Milk", time: "8am", image: "🥞"),

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
                    MealCategoryCard(
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
          Text("Daily Statistics:"),
          // Affiche ici tes statistiques quotidiennes, par exemple :
          Text("Calories consumed: 1500"),
          Text("Meals: 3"),
          // Autres statistiques
        ],
      );
    } else if (selectedFrequency == "Weekly") {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Weekly Statistics:"),
          // Affiche ici tes statistiques hebdomadaires
          Text("Calories consumed: 10500"),
          Text("Meals: 21"),
          // Autres statistiques
        ],
      );
    } else if (selectedFrequency == "Monthly") {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Monthly Statistics:"),
          // Affiche ici tes statistiques mensuelles
          Text("Calories consumed: 45000"),
          Text("Meals: 90"),
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

class MealTile extends StatelessWidget {
  final String name;
  final String time;
  final String image;

  const MealTile(
      {super.key, required this.name, required this.time, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Text(image, style: const TextStyle(fontSize: 32)),
        title: Text(name),
        subtitle: Text("Today | $time"),
        trailing: const Icon(Icons.favorite_border),
      ),
    );
  }
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
              onPressed: () {},
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
