class ApiRoutes {
  static const baseUrl = "http://127.0.0.1:5000";

  static const login = "/auth/login";
  static const reqister = "/auth/register";

  static const message = "/message";
  static String messageById(String id) => "/message/$id";
}
