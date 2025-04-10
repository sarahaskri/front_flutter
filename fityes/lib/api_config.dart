class ApiConfig {
  static const String ip = '192.168.43.151';
  static const String port = '5003';
  static const String basePath = '/api/';

  static String get baseUrl => 'http://$ip:$port$basePath';

  // Exemple d'endpoint
  static Uri register() => Uri.parse('${baseUrl}users/register');
    static Uri GoogleSignIn() => Uri.parse('${baseUrl}users/GoogleSignIn');
}
