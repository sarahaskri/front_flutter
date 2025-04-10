import 'package:flutter/material.dart';
import 'package:fityes/food_info_detail_pancake.dart';

class BreakfastInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 139, 144, 244), // Orange clair
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFF4DB6AC)), // Turquoise
        fontFamily: 'Roboto',
      ),
      home: BreakfastPage(),
    );
  }
}

class BreakfastPage extends StatelessWidget {
  final String userId = "abc123"; // normalement récupéré via Firebase

  void addMealToSchedule(String mealName, BuildContext context) {
    String mealType = "breakfast";
    String date = DateTime.now().toString().split(' ')[0];
    String time = TimeOfDay.now().format(context);

    // Ici tu feras l’appel HTTP vers Node
    print("Ajouté: $mealName, $mealType, $date, $time, user: $userId");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Repas '$mealName' ajouté à $time")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {
              // Action pour le bouton à droite
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Pancake',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                  const MealCategoryCard(
                    subtitle: "Salad",
                    imagePath: "assets/images/dinner.png",
                  ),
                  const SizedBox(width: 10),
                  const MealCategoryCardPink(
                    subtitle: "Cake",
                    imagePath: "assets/images/honey_pan.png",
                  ),
                  const MealCategoryCard(
                    subtitle: "Pie",
                    imagePath: "assets/images/apple_pie.png",
                  ),
                  const SizedBox(width: 10),
                  const MealCategoryCardPink(
                    subtitle: "Smothing",
                    imagePath: "assets/images/smothing.png",
                  ),
                ]
                    .map((w) => Padding(
                        padding: const EdgeInsets.only(right: 10), child: w))
                    .toList(),
              ),
            ),

            const SizedBox(height: 30),

            _buildSectionTitle(context, 'Recommendation \nfor Diet'),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Recomandcard(
                    title: "Honey Pancake",
                    subtitle: "Easy | 20mins | 200kCal",
                    imagePath: "assets/images/honey_pan.png",
                  ),
                  SizedBox(width: 10),
                  RecomandcardPink(
                    title: "Lunch",
                    subtitle: "130+ Foods",
                    imagePath: "assets/images/lunch.png",
                  ),
                  SizedBox(width: 10),
                  Recomandcard(
                    title: "Dinner",
                    subtitle: "100+ Foods",
                    imagePath: "assets/images/dinner.png",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle(context, 'Popular'),
            //  _buildRecipeCard(context, 'Blueberry Pancake', 'Medium | 30mins | 230kCal', 'assets/images/pancake_berry.png'),
            _buildRecipeCardWithNavigation(
              context,
              'Blueberry Pancake',
              'Medium | 30mins | 230kCal',
              'assets/images/pancake_berry.png',
            ),
            _buildRecipeCard(context, 'Salmon Night',
                'Medium | 20mins | 120kCal', 'assets/images/salmon.png'),
          ],
        ),
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

  Widget _buildRecipeCard(
      BuildContext context, String title, String details, String imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 5),
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
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Color(0xFFCC58F1), size: 20),
        onTap: () {
          // Action si tu veux
        },
      ),
    );
  }

  Widget _buildRecipeCardWithNavigation(
    BuildContext context,
    String title,
    String details,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
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
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Color(0xFFCC58F1), size: 20),
        onTap: () {
          // Navigation vers la page FoodInfoDetailsView
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodInfoDetailsView(
                mObj: {
                  "name": "Breakfast", // Type de repas
                },
                dObj: {
                  "name": title,
                  "b_image": imagePath,
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

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
        // Tu peux faire un Navigator.push ou appeler une fonction ici
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
        // Tu peux faire un Navigator.push ou appeler une fonction ici
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

///////////////////////////
class Recomandcard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const Recomandcard({
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
                "View",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecomandcardPink extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const RecomandcardPink({
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
              onPressed: () {},
              child: const Text(
                "View",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
