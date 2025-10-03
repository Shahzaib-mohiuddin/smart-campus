import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Smart Campus Companion';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your complete campus management solution';
  
  // API Endpoints (if any)
  static const String baseUrl = 'https://api.yourdomain.com';
  
  // SharedPreferences Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserData = 'user_data';
  static const String keyAuthToken = 'auth_token';
  static const String keyFcmToken = 'fcm_token';
  static const String keyThemeMode = 'theme_mode';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String classesCollection = 'classes';
  static const String librarySeatsCollection = 'library_seats';
  static const String eventsCollection = 'events';
  static const String lostFoundCollection = 'lost_found';
  static const String studyGroupsCollection = 'study_groups';
  static const String messagesCollection = 'messages';
  static const String cafeteriaMenuCollection = 'cafeteria_menu';
  static const String ordersCollection = 'orders';
  
  // Default Values
  static const String defaultAvatarUrl = 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';
  static const String defaultProfileImage = 'assets/images/placeholder.png';
  
  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashAnimationDuration = Duration(seconds: 2);
  
  // Padding and Sizes
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultButtonHeight = 56.0;
  static const double defaultAppBarHeight = kToolbarHeight;
  
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    height: 1.5,
  );
  
  // Colors
  static const Map<int, Color> primarySwatch = {
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF2196F3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  };
  
  // Validation Messages
  static const String validationRequired = 'This field is required';
  static const String validationEmail = 'Please enter a valid email address';
  static const String validationPassword = 'Password must be at least 8 characters long';
  static const String validationPhone = 'Please enter a valid phone number';
  
  // Error Messages
  static const String errorOccurred = 'An error occurred. Please try again.';
  static const String noInternet = 'No internet connection. Please check your network settings.';
  static const String serverError = 'Server error. Please try again later.';
  
  // Success Messages
  static const String loginSuccess = 'Logged in successfully';
  static const String registerSuccess = 'Account created successfully';
  static const String profileUpdateSuccess = 'Profile updated successfully';
  
  // Dialog Titles
  static const String confirmTitle = 'Are you sure?';
  static const String successTitle = 'Success';
  static const String errorTitle = 'Error';
  static const String warningTitle = 'Warning';
  
  // Button Labels
  static const String okButton = 'OK';
  static const String cancelButton = 'Cancel';
  static const String confirmButton = 'Confirm';
  static const String saveButton = 'Save';
  static const String submitButton = 'Submit';
  
  // Placeholder Texts
  static const String searchHint = 'Search...';
  static const String noDataFound = 'No data found';
  static const String noInternetConnection = 'No internet connection';
  
  // Date and Time Formats
  static const String dateFormat = 'MMM d, yyyy';
  static const String timeFormat = 'h:mm a';
  static const String dateTimeFormat = 'MMM d, yyyy h:mm a';
  
  // App Settings
  static const bool isDemoMode = false;
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableDarkMode = true;
  static const bool enableOfflineMode = true;
  
  // API Timeout
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);
  
  // Storage Directories
  static const String appDocumentsDir = 'smart_campus_companion';
  static const String tempDir = 'temp';
  static const String cacheDir = 'cache';
  static const String downloadsDir = 'downloads';
  
  // File Extensions
  static const List<String> imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
  static const List<String> documentExtensions = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.txt'];
  
  // Maximum File Sizes (in bytes)
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxDocumentSize = 10 * 1024 * 1024; // 10MB
  
  // Social Media Links
  static const String websiteUrl = 'https://yourwebsite.com';
  static const String facebookUrl = 'https://facebook.com/yourpage';
  static const String twitterUrl = 'https://twitter.com/yourhandle';
  static const String instagramUrl = 'https://instagram.com/yourprofile';
  static const String linkedinUrl = 'https://linkedin.com/company/yourcompany';
  
  // Support Information
  static const String supportEmail = 'support@yourdomain.com';
  static const String supportPhone = '+1234567890';
  static const String supportWebsite = 'https://support.yourdomain.com';
  
  // App Store Links
  static const String appStoreUrl = 'https://apps.apple.com/app/idYOUR_APP_ID';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME';
  
  // In-App Purchase IDs (if any)
  static const String premiumSubscriptionId = 'com.yourapp.premium';
  
  // API Keys (Note: In production, use flutter_dotenv or similar for sensitive data)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String sentryDsn = 'YOUR_SENTRY_DSN';
  
  // Feature-specific Constants
  static const int maxProfileImageSize = 2 * 1024 * 1024; // 2MB
  static const int maxBioLength = 250;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 8;
  
  // Notification Channels
  static const String defaultNotificationChannelId = 'default_channel';
  static const String defaultNotificationChannelName = 'General Notifications';
  static const String defaultNotificationChannelDescription = 'General notifications';
  
  // Deep Linking
  static const String deepLinkBaseUrl = 'https://yourapp.domain.com';
  static const String deepLinkPrefix = 'smartcampus';
  
  // Add any other constants as needed
}
