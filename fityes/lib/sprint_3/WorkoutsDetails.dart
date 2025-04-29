import 'package:fityes/sprint_3/addExercice.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Map<String, dynamic> exerciseData;

  const ExerciseDetailPage({Key? key, required this.exerciseData})
      : super(key: key);

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  
  List<Map<String, dynamic>> customReps = [
    {"calories": 450, "times": 29},
    {"calories": 460, "times": 30},
    {"calories": 450, "times": 31},
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final List<Map<String, String>> steps = 
        (widget.exerciseData["steps"] as List<dynamic>?)?.cast<Map<String, String>>() ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          widget.exerciseData["image"],
                          width: double.infinity,
                          height: media.width * 0.8,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow,
                              size: 40, color: Colors.black),
                        ),
                          Positioned(
                          top: 20,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Color.fromARGB(255, 0, 0, 0), size: 28),
                            onPressed: () {
                              Navigator.pop(
                                  context); // <-- pour revenir en arrière
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.exerciseData["name"],
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${widget.exerciseData["level"]} | ${widget.exerciseData["calories"]} Calories Burn",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Descriptions",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ReadMoreText(
                            widget.exerciseData["description"],
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' Read More...',
                            trimExpandedText: ' Read Less',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            moreStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "How To Do It",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${steps.length} Steps",
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          ...steps.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final step = entry.value;
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.purple.shade100,
                                          child: Text(
                                            index.toString().padLeft(2, '0'),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.purple),
                                          ),
                                        ),
                                        if (index != steps.length)
                                          Container(
                                            width: 2,
                                            height: 40,
                                            color: Colors.purple.shade100,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            step["title"]!,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            step["desc"]!,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                          const Text(
                            "Custom Repetitions",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          ...customReps.map((rep) {
                            return Row(
                              children: [
                                const Icon(Icons.local_fire_department,
                                    color: Colors.redAccent, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  "${rep["calories"]} Calories Burn",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                const Spacer(),
                                Text(
                                  "${rep["times"]} times",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: const Color.fromARGB(255, 215, 226, 249),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddExercicePage(
                                        exerciseName: widget.exerciseData["name"],
                                        workoutName: widget.exerciseData["workoutName"],
                                        imagePath: widget.exerciseData["image"],
                                        caloriesBurned: widget.exerciseData["calories"],
                                        level: widget.exerciseData["level"],
                                        description: widget.exerciseData["description"],
                                        info: widget.exerciseData["info"],
                                      
                                        )));
                },
                child: const Text("Save", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}