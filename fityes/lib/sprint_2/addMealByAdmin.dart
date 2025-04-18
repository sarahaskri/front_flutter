import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fityes/sprint_2/mealModelAdmin.dart';
import 'package:fityes/sprint_2/admin_service.dart';

class AddMealByAdmin extends StatefulWidget {
  @override
  _AddMealByAdminState createState() => _AddMealByAdminState();
}

class _AddMealByAdminState extends State<AddMealByAdmin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String selectedType = 'Breakfast';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

void _selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: 8, minute: 0),
  );
  if (picked != null) {
    final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    setState(() {
      timeController.text = formattedTime;
    });
  }
}


  void _addMeal() async {
    if (_formKey.currentState!.validate()) {
      final newMeal = Meal(
        mealName: nameController.text,
        mealType: selectedType,
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
        time: timeController.text,
        description: '',
        imagePath: '',
        nutrition: {},
       id: '',
      );

      await AdminService().addMealByAdmin(newMeal);
      Navigator.pop(context, true); // revenir à la page précédente
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un repas")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom du repas'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(labelText: 'Type'),
                items: ['Breakfast', 'Lunch', 'Dinner']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedType = val!),
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(selectedDate)),
                onTap: () => _selectDate(context),
                decoration: InputDecoration(labelText: 'Date'),
              ),
              TextFormField(
                controller: timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: InputDecoration(labelText: 'Heure'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addMeal,
                child: Text("Ajouter"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
