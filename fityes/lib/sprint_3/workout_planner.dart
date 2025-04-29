import 'package:fityes/home.dart';
import 'package:fityes/sprint_3/AB_Workout/ABWorkout.dart';
import 'package:fityes/sprint_3/FullWorkoutDetails.dart/FullWorkout.dart';
import 'package:fityes/sprint_3/LowerBodyWorkout.dart/LowerBW.dart';
import 'package:fityes/sprint_3/UpperBodyWorkout/UpperB.dart';
import 'package:fityes/sprint_3/workout_List';
import 'package:flutter/material.dart';

class WorkoutTrackerView extends StatefulWidget {
  const WorkoutTrackerView({super.key});

  @override
  _WorkoutTrackerViewState createState() => _WorkoutTrackerViewState();
}
 bool showAllWorkouts = false;

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Colors.blue[800],
      ),
      home: const WorkoutSchedule(),
    );
  }
}

class WorkoutSchedule extends StatefulWidget {
  const WorkoutSchedule({super.key});

  @override
  _WorkoutScheduleState createState() => _WorkoutScheduleState();
}

class _WorkoutScheduleState extends State<WorkoutSchedule> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back_ios),
                  const Text(
                    "Workout Tracker",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {}, // pour éviter l'erreur d'icône cliquable
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Daily Meal Schedule
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Daily Meal Schedule",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9fbef7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Check",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Upcoming Workout
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Workout',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAllWorkouts = !showAllWorkouts;
                      });
                    },
                    child: Text(
                      showAllWorkouts ? "See less" : "See more",
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
             
              const SizedBox(height: 10),
             _buildWorkoutItem('Fullbody Workout', "assets/images/FBW.png", ontap: () { 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutListPage(workoutType: 'Fullbody Workout'),
                  ));
              }),
                
              _buildWorkoutItem('Upperbody Workout', "assets/images/UBW.png"),
              if (showAllWorkouts) ...[
                _buildWorkoutItem('Lowerbody Workout', "assets/images/LBW.png"),
                _buildWorkoutItem('AB Workout', "assets/images/ABW.png"),
              ],
             
              
              const SizedBox(height: 24),

              // What Do You Want to Train
              const Text(
                'What Do You Want to Train',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              Column(
                children: [
                  WorkoutCard(
                    title: "Fullbody Workout",
                    subtitle: "6 Exercises | 45mins",
                    imagePath: "assets/images/FBW.png",
                    onPressed: () { Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const FullWorkout(
                       mObj: {
                        "name": "Fullbody Workout", // Type de repas
                      },
                      dObj: {
                         "exercise&time": "6 Exercises | 45mins", // Pass the subtitle value explicitly
                      
                        "b_image": "assets/images/FBW.png", // Replace with the correct image path
                      },

                    ),
                  ));},
                  ),
                  const SizedBox(height: 15),
                  WorkoutCard(
                    title: "Lowerbody Workout",
                    subtitle: "6 Exercises | 32mins",
                    imagePath: "assets/images/LBW.png",
                    onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const LowerBWorkout(
                       mObj: {
                        "name": "Lowerbody Workout", // Type de repas
                      },
                      dObj: {
                         "exercise&time": "6 Exercises | 32mins", // Pass the subtitle value explicitly
                      
                        "b_image": "assets/images/LBW.png", // Replace with the correct image path
                      },

                    ),
                  ));},
                  ),
                  const SizedBox(height: 15),
                  WorkoutCard(
                    title: "AB Workout",
                    subtitle: "6 Exercises | 40mins",
                    imagePath: "assets/images/ABW.png",
                    onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const ABworkout(
                       mObj: {
                        "name": "AB Workout", // Type de repas
                      },
                      dObj: {
                         "exercise&time": "6 Exercises | 40mins", // Pass the subtitle value explicitly
                      
                        "b_image": "assets/images/ABW.png", // Replace with the correct image path
                      },

                    ),
                  ));},
                  ),
                  const SizedBox(height: 15),
                  WorkoutCard(
                    title: "Upperbody Workout",
                    subtitle: "6 Exercises | 25mins",
                    imagePath: "assets/images/UBW.png",
                    onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const UpperBW(
                       mObj: {
                        "name": "Upperbody Workout", // Type de repas
                      },
                      dObj: {
                         "exercise&time": "6 Exercises | 25mins", // Pass the subtitle value explicitly
                      
                        "b_image": "assets/images/UBW.png", // Replace with the correct image path
                      },

                    ),
                  ));},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildWorkoutItem(String title, String imagePath, {VoidCallback? ontap}) {
  return Card(
    
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Image.asset(
        imagePath,
        height: 50,
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
          trailing: const Icon(Icons.arrow_forward_ios,
            color: Color(0xFFCC58F1), size: 20),
        onTap: ontap,
    ),
  );
}

  static Widget _buildTrainingCard(String title, String details) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(details),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'View more',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class WorkoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onPressed;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 221, 232, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Texte à gauche
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "View more",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Image.asset(
            imagePath,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
