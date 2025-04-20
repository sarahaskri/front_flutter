import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static String? userIdN;
  static String? userIdF;
 

  static Future<void> setUserIdN(String id) async {
    userIdN = id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userIdN', id);
    print("ID simple enregistré dans page user_session: $userIdN");
  }

  static Future<void> setUserIdF(String id) async {
    userIdF = id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userIdF', id);
  }

  static Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdN = prefs.getString('userIdN');
    userIdF = prefs.getString('userIdF');
  }
}

class UserRole {
  static String? role;

  static Future<void> setRole(String newRole) async {
    role = newRole; // Changer 'role' en 'newRole'
    SharedPreferences prefsR = await SharedPreferences.getInstance();
    await prefsR.setString('userRole', role!); // Assurez-vous que 'role' n'est pas null
    print("role enregistré dans page user_session: $role");
  }

  static Future<void> loadRole() async {
    SharedPreferences prefsR = await SharedPreferences.getInstance();
    role = prefsR.getString('userRole');
  }
}