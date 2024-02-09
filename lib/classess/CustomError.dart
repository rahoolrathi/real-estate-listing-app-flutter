class CustomError implements Exception {
  final String message;

  CustomError(this.message);

  @override
  String toString() => '$message';
}