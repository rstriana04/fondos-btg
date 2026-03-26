class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

class NotFoundException implements Exception {
  final String message;

  const NotFoundException({this.message = 'Resource not found'});

  @override
  String toString() => 'NotFoundException(message: $message)';
}

class BadRequestException implements Exception {
  final String message;

  const BadRequestException({this.message = 'Bad request'});

  @override
  String toString() => 'BadRequestException(message: $message)';
}
