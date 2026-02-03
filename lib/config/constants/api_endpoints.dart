class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // Base URL - Update this to your actual IP
  static const String baseUrl = "http://192.168.68.127:5500";

  // User service endpoints
  static const String userBaseUrl = "$baseUrl/api/users/";
  static const String userRegister = "${userBaseUrl}register";
  static const String userLogin = "${userBaseUrl}login";
  static String getUserProfile(String userId) =>
      "${userBaseUrl}profile/$userId";
  static String editUserProfile(String userId) => "${userBaseUrl}edit/$userId";
  static const String getAllUsers = "${userBaseUrl}getAll";
  static String deleteUserAccount(String userId) =>
      "${userBaseUrl}delete/$userId";
  static const String userVerifyEmail = "${userBaseUrl}verify-email";
  static const String userResendOTP = "${userBaseUrl}resend-otp";

  // Business service URL
  static const String businessBaseUrl =
      "http://192.168.68.127:5501/api/business/";
  static const String businessLogin = "${businessBaseUrl}login";
  static const String businessRegister = "${businessBaseUrl}register";
  static const String businessVerifyEmail = "${businessBaseUrl}verify-email";
  static const String businessResendOTP = "${businessBaseUrl}resend-otp";
  static const String businessProfileImage =
      "$businessBaseUrl/business/profile-image";
  static const String businessProfile = "${businessBaseUrl}profile";
  static const String businessDocuments = "${businessBaseUrl}upload-documents";
  static const String businessNearby = "${businessBaseUrl}nearby";
  static const String businessMe = "${businessBaseUrl}me";
  static const String updateBusinessProfile =
      "${businessBaseUrl}update-profile";

  static String getBusinessDetails(String id) => "$businessBaseUrl/$id";
  // Pets service URL
  static const String petsBaseUrl = "http://192.168.68.127:5502/api/pets/";

  // Public pet routes
  static String getPetsByBusiness(String businessId) =>
      "${petsBaseUrl}business/$businessId";
  static String getPetDetail(String petId) => "$petsBaseUrl$petId";
  static String getAllPets() => petsBaseUrl;

  // Authenticated business pet routes
  static String createPet() => petsBaseUrl;
  static String updatePet(String petId) => "$petsBaseUrl$petId";
  static String deletePet(String petId) => "$petsBaseUrl$petId";

  // Adoption service URL
  static const String adoptionBaseUrl =
      "http://192.168.68.127:5503/api/adoption";

  /// Apply for adoption
  static String applyForAdoption(String petId) =>
      "$adoptionBaseUrl/pets/$petId/adopt";
  static String getAdoptionStatus(String petId) =>
      "$adoptionBaseUrl/pets/$petId/status";
  static const String getUserAdoptions = "$adoptionBaseUrl/history";
  static const String getBusinessAdoptions =
      "$adoptionBaseUrl/business/history";

  static String getPetAdoptions(String petId) => "$adoptionBaseUrl/pets/$petId";
  static String updateAdoptionStatus(String adoptionId) =>
      "$adoptionBaseUrl/$adoptionId/status";
  static String markAdoptionPaid(String adoptionId) =>
      "$adoptionBaseUrl/$adoptionId/mark-paid";
  static String getAdoptionById(String adoptionId) =>
      "$adoptionBaseUrl/$adoptionId";

  // In your ApiEndpoints class
  static String notificationBaseUrl =
      "http://192.168.68.127:5505/api/notification";

  // Notification endpoints
  static String getUserNotifications = "$notificationBaseUrl/user";
  static String getBusinessNotifications = "$notificationBaseUrl/business";
  static String sendAdoptionApprovedNotification =
      "$notificationBaseUrl/adoption-approved";
  static String sendAdoptionRejectedNotification =
      "$notificationBaseUrl/adoption-rejected";
  static String clearAllNotifications = "$notificationBaseUrl/clear";

  // Payment service URL
  static String paymentBaseUrl = "http://192.168.68.127:5504/api/payments/";
  static String loadWallet = "${paymentBaseUrl}wallet/load";

  static String getWalletBalance = "${paymentBaseUrl}wallet/balance";

  static String getWalletTransactions = "${paymentBaseUrl}wallet/transactions";

  static String initiatePayment = "${paymentBaseUrl}initiate";

  static String processPayment = "${paymentBaseUrl}process";

  static String getUserPayments = "${paymentBaseUrl}user/payments";

  static String getPaymentSummary(String paymentId) =>
      "${paymentBaseUrl}summary/$paymentId";

  static String getPaymentDetails(String paymentId) =>
      "$paymentBaseUrl$paymentId";

  static String getBusinessEarnings = "${paymentBaseUrl}business/earnings";

  static String getBusinessWalletBalance =
      "${paymentBaseUrl}business/wallet/balance";

  static String getBusinessWalletTransactions =
      "${paymentBaseUrl}business/wallet/transactions";

  static String getAllTransactions = "${paymentBaseUrl}admin/transactions";
  static String getAllWallets = "${paymentBaseUrl}admin/wallets";
}
