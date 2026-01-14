class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // User service URL
  static const String userBaseUrl = "http://192.168.68.106:5500/api/user/";
  static const String userLogin = "${userBaseUrl}login";
  static const String userRegister = "${userBaseUrl}register";

  // Business service URL
  static const String businessBaseUrl =
      "http://192.168.68.106:5501/api/business/";
  static const String businessLogin = "${businessBaseUrl}login";
  static const String businessRegister = "${businessBaseUrl}register";
  static const String businessProfile = "${businessBaseUrl}profile";
  static const String businessDocuments = "${businessBaseUrl}upload-documents";
  static const String businessNearby = "${businessBaseUrl}nearby";

  // NEW BUSINESS PROFILE ENDPOINTS
  static const String businessMe = "${businessBaseUrl}me";
  static const String updateBusinessProfile =
      "${businessBaseUrl}update-profile";

  // Business details by ID (public endpoint)
  static String getBusinessDetails(String businessId) =>
      "$businessBaseUrl$businessId";

  // Pets service URL
  static const String petsBaseUrl = "http://192.168.68.106:5502/api/pets/";

  // Public pet routes
  static String getPetsByBusiness(String businessId) =>
      "${petsBaseUrl}business/$businessId";
  static String getPetDetail(String petId) => "$petsBaseUrl$petId";
  static String getAllPets() => petsBaseUrl;

  // Authenticated business pet routes
  static String createPet() => petsBaseUrl;
  static String updatePet(String petId) => "$petsBaseUrl$petId";
  static String deletePet(String petId) => "$petsBaseUrl$petId";
}
