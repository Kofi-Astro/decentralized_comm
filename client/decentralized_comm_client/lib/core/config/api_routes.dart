class ApiRoutes {
  static const String baseUrl = "http://192.168.0.50:5000";

  static const login = "/auth/login";
  static const register = "/auth/register";

  static const message = "/message";
  static String messageById(String id) => "/message/$id";
}
