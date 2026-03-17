// Constants for the MindFlow App

class AppConstants {
    // API Endpoints
    static const String baseUrl = 'https://api.mindflow.com/v1';
    static const String meditationEndpoint = '/meditations';
    static const String userEndpoint = '/users';

    // Firebase Configuration
    static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY';
    static const String firebaseAuthDomain = 'YOUR_FIREBASE_AUTH_DOMAIN';
    static const String firebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';
    static const String firebaseStorageBucket = 'YOUR_FIREBASE_STORAGE_BUCKET';

    // Meditation Categories
    static const List<String> meditationCategories = [
        'Mindfulness',
        'Sleep',
        'Focus',
        'Stress Relief',
        'Self-Love',
    ];

    // Durations
    static const List<int> meditationDurations = [5, 10, 15, 20, 30];  // durations in minutes

    // Animation Durations
    static const int shortAnimationDuration = 300;  // in milliseconds
    static const int mediumAnimationDuration = 600;  // in milliseconds
    static const int longAnimationDuration = 900;  // in milliseconds

    // Validation Patterns
    static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    static const String passwordPattern = r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{6,}$';

    // Error Messages
    static const String invalidEmailError = 'Please enter a valid email address.';
    static const String weakPasswordError = 'Password must be at least 6 characters long and contain both letters and numbers.';
}
