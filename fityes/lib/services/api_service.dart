import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.1.100:5003"; // Remplace par l'IP de ton serveur Node.js

  static Future<Map<String, dynamic>> registerUser(
      String firstname, String lastname, String email, String password) async {
    final url = Uri.parse("$baseUrl/api/users/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Échec de l'enregistrement: ${response.body}");
    }
  }

  //  Ajout de la fonction loginUser()
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final url = Uri.parse("$baseUrl/api/users/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Échec de la connexion: ${response.body}");
    }
  }

  // Fonction pour ajouter les informations de profil
  Future<String> addProfileInformation({
    required String userId,
    required String gender,
    required int age,
    required double weight,
    required double height,
  }) async {
    final url = Uri.parse("$baseUrl/api/users/addProfileInformation");

    try {
      // Création du corps de la requête avec les données du profil
      final Map<String, dynamic> profileData = {
        'userId': userId,
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
      };

      final response = await http.post(
        Uri.parse(url as String),
        headers: {
          'Content-Type':
              'application/json', // Spécifie que les données envoyées sont en JSON
        },
        body: json.encode(profileData), // Corps de la requête encodé en JSON
      );

      if (response.statusCode == 200) {
        // Si l'API répond avec succès, on retourne le message
        return 'Profile updated successfully';
      } else {
        // Si l'API répond avec une erreur, on renvoie un message d'erreur
        return 'Failed to update profile. Error: ${response.body}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  
  // Connexion via Google
  static Future<Map<String, dynamic>> loginWithGoogle(
      {required String email,
      required String firstname,
      required String lastname}) async {
    final url = Uri.parse("$baseUrl/api/users/GoogleSignIn");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Échec de la connexion Google: ${response.body}");
    }
  }

   static Future<bool> addMeal({
    required String userId,
    required String mealType,
    required String mealName,
    required String date,
    required String time,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/addMeal');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "userId": userId,
        "mealType": mealType,
        "mealName": mealName,
        "date": date,
        "time": time,
      }),
    );

    return response.statusCode == 200;
  }

   static Future<List<dynamic>> getTodayMeals({
    required String userId,
    required String mealType,
    required String date,
  }) async {
    final Uri url = Uri.parse(
      '$baseUrl/todayMeal?userId=$userId&mealType=$mealType&date=$date',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // retourne la liste des repas
      } else {
        print('Erreur serveur : ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la requête : $e');
      return [];
    }
  }
  //////////////////
   static Future<List<dynamic>> getAllMealsByAdmin() async {
    final Uri url = Uri.parse('$baseUrl/getAllMealsByAdmin');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print('Erreur serveur : ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la requête : $e');
      return [];
    }
  }

  ///// 
   static Future<bool> addMealByAdmin(Map<String, dynamic> mealData) async {
    final Uri url = Uri.parse('$baseUrl/addMealByAdmin');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(mealData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Erreur ajout : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de l\'ajout : $e');
      return false;
    }
  }

  //// 
    static Future<bool> updateMealByAdmin(String mealId, Map<String, dynamic> mealData) async {
    final Uri url = Uri.parse('$baseUrl/updateMealByAdmin/$mealId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(mealData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur modification : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de la modification : $e');
      return false;
    }
  }
  ///////// 
  static Future<bool> deleteMealByAdmin(String mealId) async {
    final Uri url = Uri.parse('$baseUrl/deleteMealByAdmin/$mealId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur suppression : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de la suppression : $e');
      return false;
    }
  }



}

