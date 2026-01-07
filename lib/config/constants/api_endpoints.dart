class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // user service url
  static const String userBaseUrl = "http://192.168.68.106:5500/api/user/";
  static const String userLogin = "${userBaseUrl}login";
  static const String userRegister = "${userBaseUrl}register";

  // business service url
  static const String businessBaseUrl =
      "http://192.168.68.106:5501/api/business/";
  static const String businessLogin = "${businessBaseUrl}login";
  static const String businessRegister = "${businessBaseUrl}register";
  static const String businessProfile = "${businessBaseUrl}profile";
  static const String businessDocuments = "${businessBaseUrl}upload-documents";
  static const String businessNearby = "${businessBaseUrl}nearby";
}
