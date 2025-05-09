import 'dart:convert';
import 'package:fityes/api_config.dart';
import 'package:fityes/sprint_1/ChangePasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:fityes/user_session.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String email;
  final String password; // Ajout du paramètre password
  final String weight;
  final String height;
  final String age;
  final String goal;

  const EditProfile({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.weight,
    required this.height,
    required this.age,
    required this.goal,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _ageController;
  late TextEditingController _goalController;

  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController(text: widget.firstname);
    _lastnameController = TextEditingController(text: widget.lastname);
    _emailController = TextEditingController(text: widget.email);
    _weightController = TextEditingController(text: widget.weight);
    _heightController = TextEditingController(text: widget.height);
    _ageController = TextEditingController(text: widget.age);
    _goalController = TextEditingController(text: widget.goal);
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    await UserSession.loadUserId();
    setState(() {
      userId = UserSession.userIdN ?? UserSession.userIdF;
      print("userId in EditProfile: $userId");
    });
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email (e.g., example@domain.com)';
    }
    return null;
  }

  // General field validation (non-empty)
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  Future<void> _updateProfile() async {
    if (_validateEmail(_emailController.text) != null ||
        _validateField(_firstnameController.text, 'First Name') != null ||
        _validateField(_lastnameController.text, 'Last Name') != null ||
        _validateField(_ageController.text, 'Age') != null ||
        _validateField(_goalController.text, 'Goal') != null ||
        _validateField(_weightController.text, 'Weight') != null ||
        _validateField(_heightController.text, 'Height') != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}users/update/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': _firstnameController.text,
          'lastname': _lastnameController.text,
          'email': _emailController.text,
          'weight': _weightController.text,
          'height': _heightController.text,
          'age': _ageController.text,
          'goal': _goalController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context); // Return to previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Edit Profile'),
        titleTextStyle: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/beauty.png'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${_firstnameController.text} ${_lastnameController.text}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(Icons.person, 'First Name', _firstnameController),
                            _buildTextField(Icons.person, 'Last Name', _lastnameController),
                            _buildTextField(Icons.email, 'Email', _emailController, validator: _validateEmail),
                            ListTile(
                              leading: const Icon(Icons.lock, color: Color(0xFF9fbef7), size: 30),
                              title: const Text('Password'),
                              subtitle: const Text('......'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangePasswordPage(
                                      password: widget.password, // Transmission du mot de passe
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildTextField(Icons.track_changes, 'Goal', _goalController),
                            _buildTextField(Icons.calendar_month, 'Age', _ageController),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Physical Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(Icons.fitness_center, 'Weight', _weightController),
                            _buildTextField(Icons.straighten, 'Height', _heightController),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9fbef7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(IconData icon, String label, TextEditingController controller, {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF9fbef7), size: 30),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator ?? (value) => _validateField(value, label),
      ),
    );
  }
}