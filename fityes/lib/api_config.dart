class ApiConfig {
  static const String ip = '192.168.1.12';
  static const String port = '5003';
  static const String basePath = '/api/';
  static const String basePathNotification = '/apinot/';
  static String get baseUrlNotification => 'http://$ip:$port$basePathNotification';
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
  static Uri getMealsByType(String mealType) =>Uri.parse('${baseUrl}users/getMealsByType?mealType=$mealType');
  static Uri addExercise() => Uri.parse('${baseUrl}users/addExercise');
  static Uri getWorkoutsByType(String workoutType, String userId) => 
  Uri.parse('${baseUrl}users/getWorkoutsByType/$userId/$workoutType');
  
  static Uri deletedWorkout(String id) => Uri.parse('${baseUrl}users/deletedWorkout/$id');
  static Uri checkWorkouts() => Uri.parse('${baseUrl}api/check-workouts');
  static Uri sendNotification() => Uri.parse('${baseUrlNotification}sendNotification'); 
  static Uri calculate_goal() => Uri.parse('${baseUrl}users/calculate_goal');
 static Uri addGoogleUser() => Uri.parse('${baseUrl}users/addGoogleUser');
 static Uri login_with_google() => Uri.parse('${baseUrl}users/login_with_google');
  static Uri getAdherentById(String userId) => Uri.parse('${baseUrl}users/getAdherentById/$userId');
   static Uri update(String userId) => Uri.parse('${baseUrl}users/update/$userId');
    static Uri updatePassword(String userId) => Uri.parse('${baseUrl}users/updatePassword/$userId');
    static Uri deleteAdherent(String userId) => Uri.parse('${baseUrl}users/deleteAdherent/$userId');

}
