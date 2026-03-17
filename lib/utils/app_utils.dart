import 'package:mind_flow/constants/constants.dart';

/// Utility helpers used across the MindFlow app.
class AppUtils {
  AppUtils._();

  /// Formats [seconds] into a human-readable string such as "5 min" or "1 h 30 min".
  static String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    if (duration.inHours > 0) {
      return '${duration.inHours} h ${duration.inMinutes.remainder(60)} min';
    }
    return '${duration.inMinutes} min';
  }

  /// Returns a greeting appropriate for the current time of day.
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// Returns `true` if [email] matches a valid email pattern.
  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailPattern).hasMatch(email);
  }

  /// Returns `true` if [password] meets minimum security requirements.
  static bool isValidPassword(String password) {
    return RegExp(AppConstants.passwordPattern).hasMatch(password);
  }

  /// Capitalizes the first letter of [text].
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Truncates [text] to [maxLength] characters, appending '…' when truncated.
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }

  /// Formats [dateTime] as a locale-agnostic "DD MMM YYYY" string.
  static String formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }
}
