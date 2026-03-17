import 'package:firebase_auth/firebase_auth.dart';

/// Base class for application-specific exceptions.
class AppException implements Exception {
  final String message;
  final Object? cause;

  const AppException(this.message, {this.cause});

  @override
  String toString() => 'AppException: $message';
}

/// Thrown when a network request fails.
class NetworkException extends AppException {
  const NetworkException([String message = 'A network error occurred.'])
      : super(message);
}

/// Thrown when authentication fails.
class AuthException extends AppException {
  const AuthException([String message = 'Authentication failed.'])
      : super(message);
}

/// Thrown when a requested resource is not found.
class NotFoundException extends AppException {
  const NotFoundException([String message = 'The requested resource was not found.'])
      : super(message);
}

/// Thrown when the user does not have permission to perform an action.
class PermissionException extends AppException {
  const PermissionException([String message = 'You do not have permission to perform this action.'])
      : super(message);
}

/// Central error handling utilities.
class AppErrorHandler {
  AppErrorHandler._();

  /// Converts any [error] to a user-friendly message string.
  static String handleError(Object error) {
    if (error is AppException) return error.message;

    if (error is FirebaseAuthException) {
      return _mapFirebaseAuthError(error.code);
    }

    return 'An unexpected error occurred. Please try again.';
  }

  static String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'A network error occurred. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
