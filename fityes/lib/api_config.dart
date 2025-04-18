class ApiConfig {
  static const String ip = '192.168.43.151';
  static const String port = '5003';
  static const String basePath = '/api/';

  static String get baseUrl => 'http://$ip:$port$basePath';

  //endpoint
  static Uri register() => Uri.parse('${baseUrl}users/register');
    static Uri googleSignIn() => Uri.parse('${baseUrl}users/GoogleSignIn');
    static Uri addMeal() => Uri.parse('${baseUrl}users/addMeal');
  static Uri login() => Uri.parse('${baseUrl}users/login');
  static Uri  addProfileInformation() => Uri.parse('${baseUrl}users/addProfileInformation');
   static Uri  todayMeal() => Uri.parse('${baseUrl}users/todayMeal');
   static Uri  getAllMealsByAdmin() => Uri.parse('${baseUrl}users/getAllMealsByAdmin');
    static Uri  addMealByAdmin() => Uri.parse('${baseUrl}users/addMealByAdmin');
  static Uri  updateMealByAdmin() => Uri.parse('${baseUrl}users/updateMealByAdmin');
  static Uri  deleteMealByAdmin() => Uri.parse('${baseUrl}users/deleteMealByAdmin');
}
