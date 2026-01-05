class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  static const String baseUrl = "http://192.168.68.106:5500/api/";

  static const String login = "user/login";
  static const String register = "user/register";
}
