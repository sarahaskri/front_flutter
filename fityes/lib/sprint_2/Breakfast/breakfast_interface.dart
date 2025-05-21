import 'dart:convert';
import 'dart:typed_data';

import 'package:fityes/api_config.dart';
import 'package:fityes/sprint_2/Breakfast/categoryMeal_list.dart';
import 'package:fityes/sprint_2/addMeal.dart';
import 'package:fityes/sprint_2/admin_service.dart';
import 'package:fityes/sprint_2/mealModelAdmin.dart';
import 'package:flutter/material.dart';
import 'package:fityes/sprint_2/Breakfast/food_info_detail_popular.dart';
import 'package:fityes/sprint_2/Breakfast/food_info_detail_popular2.dart';
import 'package:fityes/sprint_2/Breakfast/food_info_detail_panckake_recommandation.dart';
import 'package:fityes/sprint_2/Breakfast/food_info_detail_CUTLET_recommandation.dart';
import 'package:fityes/sprint_2/Breakfast/food_info_detail_SALAD_recommandation.dart';
import 'package:fityes/user_session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fityes/sprint_2/Breakfast/mealCategory.dart';

class BreakfastInterface extends StatefulWidget {
  @override
  _BreakfastInterfaceState createState() => _BreakfastInterfaceState();
}

class _BreakfastInterfaceState extends State<BreakfastInterface> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 139, 144, 244),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF4DB6AC)),
        fontFamily: 'Roboto',
      ),
      home: BreakfastPage(),
    );
  }
}

class BreakfastPage extends StatefulWidget {
  @override
  _BreakfastPageState createState() => _BreakfastPageState();
}

class _BreakfastPageState extends State<BreakfastPage> {
  String? userId;
  late Future<List<Meal>> _futureBreakfast;
  final TextEditingController _searchController = TextEditingController();
  List<MealExample> _filteredMeals = []; // Initialisé vide par défaut

  Future<List<Meal>> getMealsByType(String type) async {
    final uri = ApiConfig.getMealsByType(type);
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (res.statusCode != 200) {
      throw Exception('Erreur ${res.statusCode}');
    }
    final List<dynamic> data = json.decode(res.body);
    return data.map((e) => Meal.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  void initState() {
    super.initState();
    _futureBreakfast = getMealsByType('Breakfast');
    _loadUserId();
    _searchController.addListener(_onSearchChanged); // Écouter les changements de recherche
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    await UserSession.loadUserId();
    setState(() {
      userId = UserSession.userIdN ?? UserSession.userIdF;
      print("userId dans breakfast interface : $userId");
    });
  }

  // Fonction pour obtenir tous les repas (toutes catégories confondues)
  List<MealExample> getAllMeals() {
    List<MealExample> allMeals = [];
    categoryMeals.forEach((category, meals) {
      allMeals.addAll(meals);
    });
    return allMeals;
  }

  // Fonction appelée à chaque changement dans le champ de recherche
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMeals = []; // Définir comme vide au lieu de getAllMeals()
      } else {
        _filteredMeals = getAllMeals().where((meal) {
          return meal.name.toLowerCase().contains(query) ||
              meal.category.toLowerCase().contains(query) ||
              meal.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void addMealToSchedule(String mealName, BuildContext context) {
    String mealType = "Breakfast";
    String date = DateTime.now().toString().split(' ')[0];
    String time = TimeOfDay.now().format(context);

    print("Ajouté: $mealName, $mealType, $date, $time, user: $userId");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Repas '$mealName' ajouté à $time")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Breakfast',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Pancake',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ),
            const SizedBox(height: 40),

            _buildSectionTitle(context, 'Category'),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const MealCategoryCard(subtitle: "Salad", imagePath: "assets/images/dinner.png"),
                  const SizedBox(width: 10),
                  const MealCategoryCardPink(subtitle: "Cake", imagePath: "assets/images/honey_pan.png"),
                  const MealCategoryCard(subtitle: "Pie", imagePath: "assets/images/apple_pie.png"),
                  const SizedBox(width: 10),
                  const MealCategoryCardPink(subtitle: "Smoothie", imagePath: "assets/images/smothing.png"),
                ].map((w) => Padding(padding: const EdgeInsets.only(right: 10), child: w)).toList(),
              ),
            ),

            const SizedBox(height: 30),
            _buildSectionTitle(context, 'Recommendation \nfor Diet'),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Recomandcard1(title: "Honey Pancake", subtitle: "Easy | 200KCal", imagePath: "assets/images/honey_pan.png"),
                  SizedBox(width: 10),
                  RecomandcardPink2(title: "Readed cutlet", subtitle: "Medium | 250kCal", imagePath: "assets/images/lunch.png"),
                  SizedBox(width: 10),
                  Recomandcard3(title: "Green Salad", subtitle: "Easy | 120KCal", imagePath: "assets/images/dinner.png"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle(context, 'Popular'),
            _buildRecipeCarforpopular_1(context, 'Blueberry Pancake', 'Medium | 30mins | 230kCal', 'assets/images/pancake_berry.png'),
            _buildRecipeCarforpopular_2(context, 'Basil omelette', 'Medium | 20mins | 120kCal', 'assets/images/omelette.png'),
            const SizedBox(height: 30),
            _buildSectionTitle(context, 'All Breakfast'),

            // Liste des repas filtrés
            if (_filteredMeals.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('No meals found')),
              )
            else
              ..._filteredMeals.asMap().entries.map((entry) {
                final index = entry.key;
                final meal = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      meal.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                    ),
                    title: Text(
                      meal.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${meal.category}'),
                        Text(meal.description),
                        const SizedBox(height: 4),
                        Text(
                          'Calories: ${meal.nutrition['Calories']} | ${meal.nutrition['Proteins']} Proteins',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFF7EB6FF)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddMealPage(
                              mealType: "Breakfast",
                              mealName: meal.name,
                              imagepath: meal.imagePath,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicRecipeTile(BuildContext ctx, Meal meal) {
    Uint8List? bytes;

    if (meal.imagePath.isNotEmpty) {
      try {
        bytes = base64Decode(meal.imagePath);
      } catch (e) {
        print('Error decoding image: $e');
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: bytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  bytes,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.fastfood, size: 40, color: Colors.grey);
                  },
                ),
              )
            : const Icon(Icons.fastfood, size: 40, color: Colors.grey),
        title: Text(meal.mealName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${meal.time} · ${meal.date}'),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromARGB(255, 3, 3, 3),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, String title, String details, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(imagePath, height: 50, width: 50),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          details,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFCC58F1), size: 20),
        onTap: () {
          // Action si tu veux
        },
      ),
    );
  }

  Widget _buildRecipeCarforpopular_1(BuildContext context, String title, String details, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(imagePath, height: 50, width: 50),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          details,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFCC58F1), size: 20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodInfoDetailsView1(
                mObj: const {"name": "Breakfast"},
                dObj: {"name": title, "b_image": imagePath},
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecipeCarforpopular_2(BuildContext context, String title, String details, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(imagePath, height: 50, width: 50),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          details,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFCC58F1), size: 20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodInfoDetailsView2(
                mObj: const {"name": "Breakfast"},
                dObj: {"name": title, "b_image": imagePath},
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widgets existants (MealCategoryCard, Recomandcard1, etc.) restent inchangés
// (Inclus dans le code précédent pour référence)

// Widgets existants (MealCategoryCard, Recomandcard1, etc.) restent inchangés
class MealCategoryCard extends StatelessWidget {
  final String subtitle;
  final String imagePath;

  const MealCategoryCard({
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryMealList(
              mObj: const {
                "name": "Breakfast", // Type de repas
              },
              dObj: {
                "name": subtitle,
                "b_image": imagePath,
              },
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 193, 210, 246), Color(0xFFf7f8fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
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
              height: 40,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color.fromARGB(255, 16, 16, 16),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///cardmodel2
class MealCategoryCardPink extends StatelessWidget {
  final String subtitle;
  final String imagePath;

  const MealCategoryCardPink({
    super.key,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryMealList(
              mObj: const {
                "name": "Breakfast", // Type de repas
              },
              dObj: {
                "name": subtitle,
                "b_image": imagePath,
              },
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFDDDE6), Color(0xFFD8B5FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
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
              height: 40,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color.fromARGB(255, 16, 16, 16),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recomandcard1 extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const Recomandcard1({
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
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodInfoDetailsViewREC1(
                      mObj: const {
                        "name": "Breakfast",
                      },
                      dObj: {
                        "name": title,
                        "b_image": imagePath,
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                "View",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecomandcardPink2 extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const RecomandcardPink2({
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
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle,
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
                colors: [Color.fromARGB(255, 250, 156, 183), Color(0xFFD8B5FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodInfoDetailsViewREC2(
                      mObj: const {
                        "name": "Breakfast",
                      },
                      dObj: {
                        "name": title,
                        "b_image": imagePath,
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                "View",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Recomandcard3 extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const Recomandcard3({
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
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodInfoDetailsViewREC3(
                      mObj: const {
                        "name": "Breakfast",
                      },
                      dObj: {
                        "name": title,
                        "b_image": imagePath,
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                "View",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
