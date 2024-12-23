class AppConfig {
  static const bool isDevelopment = true;

  // Production URL (when you deploy)
  static const String productionBaseUrl = "http://192.168.1.109:8080/api";

  // Development URL - can be easily updated
  static const String developmentBaseUrl = "http://192.168.1.109:8080/api";

  static String get baseUrl {
    return isDevelopment ? developmentBaseUrl : productionBaseUrl;
  }
}
