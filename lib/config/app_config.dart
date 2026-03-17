// App configuration and environment variables

class AppConfig {
  // Environment
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  // Firebase
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );
  static const String firebaseAuthDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
    defaultValue: '',
  );
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );
  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: '',
  );
  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '',
  );
  static const String firebaseAppId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '',
  );

  // App
  static const String appName = 'MindFlow';
  static const String appVersion = '1.0.0';
  static const int maxFavorites = 50;
  static const int sessionTimeoutMinutes = 30;

  // Pagination
  static const int defaultPageSize = 20;

  // Audio
  static const double defaultVolume = 0.8;
  static const int audioFadeDurationMs = 1000;
}
