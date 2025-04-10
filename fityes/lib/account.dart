// account.dart
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fityes/LoginPage.dart';
import 'package:fityes/profilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fityes/api_config.dart'; 

late TextEditingController _firstnameController;
late TextEditingController _lastnameController;
late TextEditingController _emailController;
late TextEditingController _passwordController;
late GlobalKey<FormState> _formKey;
bool _isObsecure = true;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    Map<String, String> userData = {
      "firstname": _firstnameController.text,
      "lastname": _lastnameController.text,
      "email": _emailController.text,
      "password": _passwordController.text
    };
     final baseUrl = ApiConfig.register(); 
   
    try {
      final response = await http.post(
        baseUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userEmail', _emailController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie !')),
        );

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(email: _emailController.text),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 25),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hey there,',
                  style: TextStyle(fontSize: 20, color: Colors.grey)),
              const SizedBox(height: 8),
              const Text('Create an Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildTextField(
                  _firstnameController, 'First Name', Icons.person_outline),
              const SizedBox(height: 15),
              _buildTextField(
                  _lastnameController, 'Last Name', Icons.person_outline),
              const SizedBox(height: 15),
              _buildTextField(_emailController, 'Email', Icons.email_outlined,
                  isEmail: true),
              const SizedBox(height: 15),
              _buildPasswordField(),
              const SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  const Expanded(
                    child: Text(
                      'By continuing, you accept our Privacy Policy and Terms of Use.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color(0xFF9fbef7),
                  ),
                  child: const Text('Register',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[300])),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                  Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[300])),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton("assets/images/google.png", () async {
                    UserCredential? userCredential =
                        await _auth.loginWithGoogle();
                    if (userCredential != null) {
                      final email = userCredential.user?.email;
                      if (email != null && mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(email: email)),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Échec de la connexion avec Google.')),
                      );
                    }
                  }),
                  const SizedBox(width: 20),
                  _buildSocialButton("assets/images/facebook.png", () {
                    // Facebook login à ajouter si nécessaire
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text("Login",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
      validator: RequiredValidator(errorText: '$label is required').call,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: _isObsecure,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _isObsecure = !_isObsecure),
          icon:
              Icon(_isObsecure ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
      validator: RequiredValidator(errorText: 'Password is required').call,
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
        child: Image.asset(assetPath, height: 30, width: 30),
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Déconnexion de Google pour éviter les anciennes sessions
      await GoogleSignIn().signOut();

      // Tentative de connexion avec Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null)
        return null; // Si l'utilisateur annule la connexion, retourne null

      // Authentification avec Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connexion avec Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Récupération des informations utilisateur
        final email = user.email ?? "";
        final fullName = user.displayName ?? "";
        final uid = user.uid;

        // Séparation du nom complet en prénom et nom de famille
        final nameParts = fullName.split(" ");
        final firstName = nameParts.isNotEmpty ? nameParts[0] : "";
        final lastName = nameParts.length > 1 ? nameParts[1] : "";

        // URL de l'API
         final baseUrl = ApiConfig.GoogleSignIn(); 
      

        // Envoi des données utilisateur au backend
        final response = await http.post(
          baseUrl, // Utilisation directe de la chaîne de caractères pour l'URL
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "uid": uid,
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
          }),
        );

        if (response.statusCode == 200) {
          print("Utilisateur Google enregistré !");
        } else {
          print("Erreur backend : ${response.body}");
        }
      }

      return userCredential; // Retourne les informations d'authentification de l'utilisateur
    } catch (e) {
      print("Erreur Google Sign-In: $e");
      return null; // En cas d'erreur, retourne null
    }
  }
}
