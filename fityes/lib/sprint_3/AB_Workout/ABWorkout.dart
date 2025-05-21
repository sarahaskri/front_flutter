import 'package:fityes/sprint_3/AB_Workout/ExerciseData.dart';
import 'package:fityes/sprint_3/FullWorkoutDetails.dart/ExerciseData.dart';
import 'package:fityes/sprint_3/WorkoutsDetails.dart';
import 'package:flutter/material.dart';
import 'package:fityes/home.dart';
import 'package:fityes/sprint_2/colo_extension.dart';
import 'package:fityes/sprint_2/round_boutton.dart';
import 'package:fityes/sprint_2/food_step_detail.dart';
import 'package:fityes/sprint_2/addMeal.dart';
import 'package:fityes/sprint_2/meal_schudle.dart';
import 'package:readmore/readmore.dart';

class ABworkout extends StatefulWidget {
  final Map mObj;
  final Map dObj;
  const ABworkout({super.key, required this.dObj, required this.mObj});

  @override
  State<ABworkout> createState() => _ABworkoutState();
}

class _ABworkoutState extends State<ABworkout> {
  String selectedDifficulty = 'Easy';
  String? selectedExerciseImage;

  final List<Map<String, dynamic>> abWorkoutSets = [
    {
      "setName": "Set 1",
      "exercises": [
        {
          "image": "assets/images/crunches.jpg",
          "name": "Crunches",
          "info": "20x",
          "caloriesEasy": 5,
          "caloriesMedium": 7,
          "caloriesHard": 10,
          "description":
              "Crunches are an effective exercise that targets the abdominal muscles, specifically the upper abs.",
          "steps": stepsForCrunches,
        },
        {
          "image": "assets/images/leg_raises.jpg",
          "name": "Leg Raises",
          "info": "15x",
          "caloriesEasy": 6,
          "caloriesMedium": 8,
          "caloriesHard": 12,
          "description":
              "Leg raises engage the lower abdominal muscles and help build a strong core.",
          "steps": stepsForLegRaises,
        },
      ],
    },
    {
      "setName": "Set 2",
      "exercises": [
        {
          "image": "assets/images/plank.jpg",
          "name": "Plank",
          "info": "16x",
          "caloriesEasy": 4,
          "caloriesMedium": 6,
          "caloriesHard": 8,
          "description":
              "The plank is an isometric exercise that works the entire core, including abs, back, and shoulders.",
          "steps": stepsForPlank,
        },
        {
          "image": "assets/images/bicycle_crunch.jpeg",
          "name": "Bicycle Crunches",
          "info": "20x",
          "caloriesEasy": 7,
          "caloriesMedium": 9,
          "caloriesHard": 12,
          "description":
              "Bicycle crunches engage both the upper and lower abs while also working the obliques.",
          "steps": stepsForBicycleCrunch,
        },
      ],
    },
    {
      "setName": "Set 3",
      "exercises": [
        {
          "image": "assets/images/mountain_climbers.jpg",
          "name": "Mountain Climbers",
          "info": "15x",
          "caloriesEasy": 6,
          "caloriesMedium": 8,
          "caloriesHard": 12,
          "description":
              "Mountain climbers are a full-body exercise that also targets the core, specifically the abs.",
          "steps": stepsForMountainClimbers,
        },
        {
          "image": "assets/images/russian_twists.jpg",
          "name": "Russian Twists",
          "info": "20x",
          "caloriesEasy": 5,
          "caloriesMedium": 7,
          "caloriesHard": 10,
          "description":
              "Russian twists target the obliques, enhancing core rotation and building strength in the sides of the torso.",
          "steps": stepsForRussianTwists,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: TColor.lightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    "assets/images/black_btn.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
             
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: ClipRect(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Transform.scale(
                      scale: 1.25,
                      child: Container(
                        width: media.width * 0.55,
                        height: media.width * 0.55,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                              BorderRadius.circular(media.width * 0.275),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.25,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          selectedExerciseImage ??
                              widget.dObj["b_image"].toString(),
                          width: media.width * 0.50,
                          height: media.width * 0.50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 10,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: TColor.gray.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.width * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mObj["name"].toString(),
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                widget.dObj["exercise&time"].toString(),
                                style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Image.asset(
                            "assets/images/fav.png",
                            width: 15,
                            height: 15,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.swap_vert,
                              color: Color.fromARGB(255, 202, 136, 250),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Difficulty',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 202, 136, 250),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton<String>(
                            value: selectedDifficulty,
                            items: ['Easy', 'Medium', 'Hard']
                                .map((level) => DropdownMenuItem(
                                      value: level,
                                      child: Text(
                                        level,
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 202, 136, 250),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDifficulty = value!;
                              });
                            },
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 202, 136, 250)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'You\'ll Need',
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '5 Items',
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: media.width * 0.05),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildItem(
                                  "assets/images/roll.png", "Foam Roller"),
                              const SizedBox(width: 10),
                              _buildItem("assets/images/bands.png",
                                  "Resistance Bands"),
                              const SizedBox(width: 10),
                              _buildItem("assets/images/plastic-bottle.png",
                                  "Bottle of Water"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: abWorkoutSets.length,
                            itemBuilder: (context, setIndex) {
                              final set = abWorkoutSets[setIndex];
                              return Card(
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Set Name
                                      Text(
                                        set["setName"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // List of Exercises in the Set
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: set["exercises"].length,
                                        itemBuilder: (context, exerciseIndex) {
                                          final exercise =
                                              set["exercises"][exerciseIndex];
                                          return Card(
                                            elevation: 3,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(16),
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  exercise["image"],
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              title: Text(
                                                exercise["name"],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(exercise["info"]),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    'Calories: ${exercise["calories${selectedDifficulty}"]} kcal',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ],
                                              ),
                                              trailing: const Icon(Icons
                                                  .arrow_forward_ios_rounded),
                                              onTap: () {
                                                // Navigate to ExerciseDetailPage
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExerciseDetailPage(
                                                      exerciseData: {
                                                        "name":
                                                            exercise["name"],
                                                        "image":
                                                            exercise["image"],
                                                        "level":
                                                            selectedDifficulty,
                                                        "calories": exercise[
                                                            "calories${selectedDifficulty}"],
                                                        "description": exercise[
                                                            "description"],
                                                        "steps":
                                                            exercise["steps"],
                                                        "workoutName":
                                                            widget.mObj["name"],
                                                        "info":
                                                            exercise["info"],
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String imagePath, String title) {
    return Column(
      children: [
        MealCategoryCard(imagePath: imagePath),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class MealCategoryCard extends StatelessWidget {
  final String imagePath;

  const MealCategoryCard({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 219, 223, 231), Color(0xFFf7f8fc)],
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
      child: Image.asset(
        imagePath,
        height: 80,
      ),
    );
  }
}
