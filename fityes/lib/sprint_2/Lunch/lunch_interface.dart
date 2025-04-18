import 'package:fityes/sprint_2/Breakfast/categoryMeal_list.dart';
import 'package:fityes/sprint_2/Lunch/categoryMeal_listLunch.dart';
import 'package:fityes/sprint_2/Lunch/food_info_detail_recommandation1%20copy%202.dart';
import 'package:fityes/sprint_2/Lunch/food_info_detail_recommandation2.dart';
import 'package:fityes/sprint_2/Lunch/food_info_detail_recommandation3.dart';
import 'package:flutter/material.dart';
import 'package:fityes/sprint_2/Breakfast/food_info_detail_popular.dart';
import 'package:fityes/sprint_2/Breakfast/food_info_detail_popular2.dart';
import 'package:fityes/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LunchInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 139, 144, 244), // Orange clair
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFF4DB6AC)), // Turquoise
        fontFamily: 'Roboto',
      ),
      home: LunchPage(),
    );
  }
}

class LunchPage extends StatefulWidget {
  @override
  _LunchPagePageState createState() => _LunchPagePageState();
}

class _LunchPagePageState extends State<LunchPage> {
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
      print("userId dans lunch interface : $userId");
    });
  }

  void addMealToSchedule(String mealName, BuildContext context) {
    String mealType = "lunch";
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
          'Lunch',
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
                  hintText: 'Search ',
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
                    subtitle: "Steak",
                    imagePath: "assets/images/steak.png",
                  ),
                  const MealCategoryCard(
                    subtitle: "Sandwich",
                    imagePath: "assets/images/sandwich.png",
                  ),
                  const SizedBox(width: 10),
                  const MealCategoryCardPink(
                    subtitle: "Pasta",
                    imagePath: "assets/images/pasta.png",
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
                  Recomandcard1(
                    title: "Quinoa Chicken Bowl",
                    subtitle: "Medium | 370KCal",
                    imagePath: "assets/images/quinoa_bowl.png",
                  ),
                  SizedBox(width: 10),
                  RecomandcardPink2(
                    title: "Avocado Egg Sandwich",
                    subtitle: "Easy | 330KCal",
                    imagePath: "assets/images/avocado_egg_sandwich.png",
                  ),
                  SizedBox(width: 10),
                  Recomandcard3(
                    title: "Grilled Veggie Wrap",
                    subtitle: "Easy | 290KCal",
                    imagePath: "assets/images/veggie_wrap.png",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle(context, 'Popular'),
            //  _buildRecipeCard(context, 'Blueberry Pancake', 'Medium | 30mins | 230kCal', 'assets/images/pancake_berry.png'),
            _buildRecipeCarforpopular_1(
              context,
              'Blueberry Pancake',
              'Medium | 30mins | 230kCal',
              'assets/images/pancake_berry.png',
            ),
            _buildRecipeCarforpopular_2(
                context,
                'Basil omelette',
                'Medium | 20mins | 120kCal',
                'assets/images/omelette.png'),
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

  Widget _buildRecipeCarforpopular_1(
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
              builder: (context) => FoodInfoDetailsView1(
                mObj: const {
                  "name": "Lunch", // Type de repas
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

Widget _buildRecipeCarforpopular_2(
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
            builder: (context) => FoodInfoDetailsView2(
              mObj: const {
                "name": "Lunch", // Type de repas
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
            builder: (context) => CategoryMealListLunch(
              mObj: const {
                "name": "Lunch", // Type de repas
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryMealListLunch(
              mObj: const {
                "name": "Lunch", // Type de repas
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
                // Navigation vers la page FoodInfoDetailsView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodInfoDetailsViewLunchREC1(
                      mObj: const {
                        "name": "Lunch", // Type de repas
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
          )
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodInfoDetailsViewLunchREC2(
                      mObj: const {
                        "name": "Lunch", // Type de repas
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
          )
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
                // Navigation vers la page FoodInfoDetailsView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodInfoDetailsViewLunchREC3(
                      mObj: const {
                        "name": "Lunch", // Type de repas
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
          )
        ],
      ),
    );
  }
}
