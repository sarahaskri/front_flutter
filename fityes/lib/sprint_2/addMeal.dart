import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fityes/api_config.dart';
import '../user_session.dart';

class AddMealPage extends StatefulWidget {
  final String mealName;
  final String mealType; // Ajouter le paramètre mealType

  AddMealPage({required this.mealName, required this.mealType});

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat timeFormat = DateFormat('HH:mm');

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
      print("userId dans addmeal: $userId");
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to ${widget.mealType} Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélection de la date
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Select Date',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).unfocus();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    dateController.text = dateFormat.format(pickedDate);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Sélection de l'heure
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Select Time',
                hintText: 'HH:mm',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).unfocus();
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                    final formattedTime = timeFormat.format(
                      DateTime(0, 1, 1, pickedTime.hour, pickedTime.minute),
                    );
                    timeController.text = formattedTime;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (dateController.text.isNotEmpty &&
                    timeController.text.isNotEmpty &&
                    userId != null) {
                  addMealToDatabase(
                    mealType: widget.mealType, // ex: breakfast
                    mealName: widget.mealName,
                    date: dateController.text,
                    time: timeController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a date and time')),
                  );
                }
              },
              child: const Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMealToDatabase({
    required String mealType,
    required String mealName,
    required String date,
    required String time,
  }) async {
    /////////////////////////////*********************//////////////////////////
    final baseUrl = ApiConfig.addMeal();

    final response = await http.post(
      baseUrl, // Use baseUrl directly as a String
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "mealType": mealType,
        "mealName": mealName,
        "date": date,
        "time": time,
      }),
    );
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      print(" Meal added successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal added successfully')),
      );
    } else {
      print(" Failed to add meal");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add meal')),
      );
    }
  }
}
