import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fityes/api_config.dart';
import 'package:fityes/user_session.dart';

class ProgressTrackingPage extends StatefulWidget {
  const ProgressTrackingPage({super.key});

  @override
  _ProgressTrackingPageState createState() => _ProgressTrackingPageState();
}

class _ProgressTrackingPageState extends State<ProgressTrackingPage> {
  String? userId;
  double? targetWeight;
  double? initialWeight; // Added to store the starting weight
  String? goal;
  double? currentWeight;
  double? weightDifference;
  double? progressPercentage;
  bool isLoading = false;
  final TextEditingController _currentWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchGoal();
  }

  Future<void> _loadUserIdAndFetchGoal() async {
    setState(() {
      isLoading = true;
    });

    await UserSession.loadUserId();
    setState(() {
      userId = UserSession.userIdN ?? UserSession.userIdF;
      print("userId in ProgressTrackingPage: $userId");
    });

    if (userId != null) {
      await _fetchGoalData();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchGoalData() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}users/getGoal_targetWieght/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final goalData = json.decode(response.body);
        setState(() {
          targetWeight = double.tryParse(goalData['targetWeight']?.toString() ?? '0') ?? 0;
          initialWeight = double.tryParse(goalData['initialWeight']?.toString() ?? '0') ?? 0; // Fetch initial weight
          goal = goalData['goal'] ?? 'unknown';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch goal: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching goal: $e')),
      );
    }
  }

  void _compareWeights() {
    if (_currentWeightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your current weight')),
      );
      return;
    }

    setState(() {
      currentWeight = double.tryParse(_currentWeightController.text) ?? 0;

      if (currentWeight != null && targetWeight != null && initialWeight != null) {
        weightDifference = (currentWeight! - targetWeight!).abs();

        // Progress calculation for different goals
        if (goal?.toLowerCase().contains('lose weight') == true) {
          if (initialWeight! <= targetWeight!) {
            progressPercentage = 100.0; // If initial weight is already at or below target
          } else {
            double totalToLose = (initialWeight! - targetWeight!).clamp(0, double.infinity);
            double lost = (initialWeight! - currentWeight!).clamp(0, totalToLose);
            progressPercentage = totalToLose == 0 ? 100.0 : (lost / totalToLose * 100).clamp(0.0, 100.0);
          }
        } else if (goal?.toLowerCase().contains('gain weight') == true ||
                   goal?.toLowerCase().contains('build muscle') == true) {
          if (initialWeight! >= targetWeight!) {
            progressPercentage = 100.0; // If initial weight is already at or above target
          } else {
            double totalToGain = (targetWeight! - initialWeight!).clamp(0, double.infinity);
            double gained = (currentWeight! - initialWeight!).clamp(0, totalToGain);
            progressPercentage = totalToGain == 0 ? 100.0 : (gained / totalToGain * 100).clamp(0.0, 100.0);
          }
        } else {
          progressPercentage = 0.0; // Default for unknown goal
        }

        // Handle exact match with target
        if (currentWeight == targetWeight) {
          progressPercentage = 100.0;
        }
      }
    });
  }

  String _getAdviceBasedOnGoal() {
    if (goal == null || goal == 'unknown') return 'Please set a goal to receive advice.';
    
    if (goal!.toLowerCase().contains('lose weight')) {
      return 'Focus on a calorie deficit diet, incorporate cardio exercises, and stay hydrated. Aim for 1-2 pounds of weight loss per week.';
    } else if (goal!.toLowerCase().contains('gain weight')) {
      return 'Increase your protein intake, focus on strength training, and eat calorie-dense foods like nuts and avocados.';
    } else if (goal!.toLowerCase().contains('build muscle')) {
      return 'Balance your calorie intake with expenditure, maintain a consistent workout routine, and monitor your progress weekly.';
    }
    return 'Set a specific goal to receive tailored advice.';
  }

  String _getProgressMessage() {
    if (goal == null || goal == 'unknown' || currentWeight == null || targetWeight == null) {
      return 'Enter your current weight to see progress.';
    }

    if (goal!.toLowerCase().contains('lose weight')) {
      return currentWeight! > targetWeight!
          ? 'You need to lose ${weightDifference!.toStringAsFixed(1)} kg to reach your target.'
          : currentWeight! < targetWeight!
              ? 'You are below your target! Consider adjusting your goal.'
              : 'Congratulations! You’ve reached your target weight!';
    } else if (goal!.toLowerCase().contains('gain weight') || goal!.toLowerCase().contains('build muscle')) {
      return currentWeight! < targetWeight!
          ? 'You need to gain ${weightDifference!.toStringAsFixed(1)} kg to reach your target.'
          : currentWeight! > targetWeight!
              ? 'You have exceeded your target! Consider adjusting your goal.'
              : 'Congratulations! You’ve reached your target weight!';
    }
    return 'Progress cannot be determined. Set a valid goal.';
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: const Text(
          'Progress Tracking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,  
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weight Comparison Section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Weight Comparison',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Target Weight: ${targetWeight?.toStringAsFixed(1) ?? 'Loading...'} kg',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _currentWeightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Current Weight (kg)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.fitness_center, color: Color(0xFF7EB6FF)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7EB6FF), Color(0xFFB5AFFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: _compareWeights,
                              child: const Text(
                                'Compare',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Statistics Section
                  if (weightDifference != null && progressPercentage != null)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Progress Statistics',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Weight Difference: ${weightDifference!.toStringAsFixed(1)} kg',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Progress Towards Goal: ${progressPercentage!.toStringAsFixed(1)}%',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: progressPercentage! / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7EB6FF)),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _getProgressMessage(),
                              style: TextStyle(
                                fontSize: 16,
                                color: (currentWeight == targetWeight || progressPercentage == 100)
                                    ? Colors.green
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Advice Section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personalized Advice',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Goal: ${goal ?? 'Loading...'}',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _getAdviceBasedOnGoal(),
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}