/// Core constants for the DairyTrack application
class AppConstants {
  // App Information
  static const String appName = 'DairyTrack';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional Dairy Delivery Management System';
  
  // API Configuration (for future use)
  static const String baseUrl = 'https://api.dairytrack.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;
  
  // Business Rules
  static const double defaultCreditLimit = 5000.0;
  static const double maxCreditLimit = 50000.0;
  static const int maxDeliveryDays = 7;
  static const int maxDeliveryItems = 20;
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';
  
  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Debounce Duration
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);
  
  // Retry Configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
