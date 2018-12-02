class AuthenticationError implements Exception {
  AuthenticationError(this.message);
  final String message;
  String toString() => 'AuthenticationError: $message';
}