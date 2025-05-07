import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fityes/dashboardHome.dart';
import 'package:fityes/principal_dash.dart';
import 'package:fityes/sprint_1/dashboardClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fityes/sprint_1/account.dart';
import 'package:fityes/home.dart';
import 'package:http/http.dart' as http;
import 'package:fityes/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObsecure = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Veuillez remplir tous les champs.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final baseUrl = ApiConfig.login();
      final response = await http.post(
        baseUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final user = responseData['user'] ?? responseData;

        if (user['_id'] == null) {
          _showErrorDialog("ID utilisateur introuvable dans la réponse.");
          return;
        }
        // Sauvegarde des données
        await UserSession.setUserIdN(user['_id']);
        await UserRole.setRole(user['role']);

        print(
            "Connexion réussie - ID: ${UserSession.userIdN}, Role: ${UserRole.role}");
        ///////////////
        ///  Future<void> _loadUserId() async

        /////////test notification///////
        await checkWorkoutAndNotify(); //
        // Navigation en fonction du rôle
        if (user['role'] == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AdminDashboardPage()), // Remplacez par la page admin si nécessaire
          );
          return; // Ajout d'un return pour éviter d'exécuter le code suivant
        } else if (user['role'] == 'adherent') {
          final userId = UserSession.userIdN;
          print('userId dans login : $userId');
          String? userGoal;
          try {
            final goalResponse = await http.get(
              Uri.parse('${ApiConfig.baseUrl}users/getGoal/$userId'),
            );

            if (goalResponse.statusCode == 200) {
              final goalData = json.decode(goalResponse.body);
              userGoal = goalData['goal'];
            } else {
              print('Goal introuvable');
              userGoal = "unknown";
            }
          } catch (e) {
            print('Erreur lors de la récupération du goal: $e');
            userGoal = "unknown";
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardHome(
                    goal: userGoal ?? 'unknown')), // Replace 'defaultGoal' with the appropriate value or variable
          );
          return; // Ajout d'un return pour éviter d'exécuter le code suivant
        } else {
          _showErrorDialog("Rôle utilisateur non reconnu.");
          return; // Ajout d'un return pour éviter d'exécuter le code suivant
        }
      } else {
        final errorData = json.decode(response.body);
        _showErrorDialog(
            errorData['message'] ?? 'Adresse e-mail ou mot de passe erroné.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Erreur: $e");
      _showErrorDialog('Erreur de connexion au serveur.');
    }
  }

  Future<void> checkWorkoutAndNotify() async {
    await UserSession.loadUserId();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final userId = UserSession.userIdN;

    if (userId != null && fcmToken != null) {
      try {
        final response = await http.post(
          ApiConfig.sendNotification(), // Nouveau endpoint
          body: json.encode({'userId': userId, 'fcmToken': fcmToken}),
          headers: {'Content-Type': 'application/json'},
        );

        final data = json.decode(response.body);
        if (data['success'] == true && data['workoutsCount'] > 0) {
          print('Notification envoyée: ${data['message']}');
        } else {
          print('Aucun exercice: ${data['message']}');
        }
      } catch (e) {
        print('Erreur notification: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 25),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back,',
                    style: TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(height: 8),
                const Text('Login to your Account',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Email is required'),
                    EmailValidator(errorText: 'Enter a valid email address'),
                  ]),
                ),
                const SizedBox(height: 15),

                // Password Field
                TextFormField(
                  obscureText: _isObsecure,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _isObsecure = !_isObsecure),
                      icon: Icon(_isObsecure
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  validator:
                      RequiredValidator(errorText: 'Password is required'),
                ),
                const SizedBox(height: 15),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              loginUser(_emailController.text,
                                  _passwordController.text);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xFF9fbef7),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),

                // OR Divider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child:
                            Divider(color: Colors.grey.shade400, thickness: 1)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Or', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(
                        child:
                            Divider(color: Colors.grey.shade400, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 15),

                // Social Media Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton("assets/images/google.png",
                        () => print("Google Login")),
                    const SizedBox(width: 20),
                    _buildSocialButton("assets/images/facebook.png",
                        () => print("Facebook Login")),
                  ],
                ),
                const SizedBox(height: 30),
///////////////////////
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don’t have an account? ',
                        style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Home()), // Remplace `RegisterPage()`
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
        child: Image.asset(assetPath, width: 30),
      ),
    );
  }
}
