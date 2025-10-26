/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic data;

  const AppException({
    required this.message,
    this.code,
    this.data,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Server related exceptions
class ServerException extends AppException {
  const ServerException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Validation related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Cache related exceptions
class CacheException extends AppException {
  const CacheException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Permission related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// File related exceptions
class FileException extends AppException {
  const FileException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Database related exceptions
class DatabaseException extends AppException {
  const DatabaseException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Business logic related exceptions
class BusinessException extends AppException {
  const BusinessException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Unknown exceptions
class UnknownException extends AppException {
  const UnknownException({
    required String message,
    String? code,
    dynamic data,
  }) : super(message: message, code: code, data: data);
}

/// Error codes for different types of errors
class ErrorCodes {
  // Network errors
  static const String networkError = 'NETWORK_ERROR';
  static const String timeoutError = 'TIMEOUT_ERROR';
  static const String connectionError = 'CONNECTION_ERROR';
  
  // Server errors
  static const String serverError = 'SERVER_ERROR';
  static const String badRequest = 'BAD_REQUEST';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String forbidden = 'FORBIDDEN';
  static const String notFound = 'NOT_FOUND';
  static const String internalServerError = 'INTERNAL_SERVER_ERROR';
  
  // Authentication errors
  static const String invalidCredentials = 'INVALID_CREDENTIALS';
  static const String tokenExpired = 'TOKEN_EXPIRED';
  static const String accountLocked = 'ACCOUNT_LOCKED';
  static const String accountDisabled = 'ACCOUNT_DISABLED';
  
  // Validation errors
  static const String validationError = 'VALIDATION_ERROR';
  static const String requiredField = 'REQUIRED_FIELD';
  static const String invalidFormat = 'INVALID_FORMAT';
  static const String invalidLength = 'INVALID_LENGTH';
  static const String invalidRange = 'INVALID_RANGE';
  
  // Cache errors
  static const String cacheError = 'CACHE_ERROR';
  static const String cacheNotFound = 'CACHE_NOT_FOUND';
  static const String cacheWriteError = 'CACHE_WRITE_ERROR';
  
  // Permission errors
  static const String permissionDenied = 'PERMISSION_DENIED';
  static const String cameraPermissionDenied = 'CAMERA_PERMISSION_DENIED';
  static const String storagePermissionDenied = 'STORAGE_PERMISSION_DENIED';
  
  // File errors
  static const String fileNotFound = 'FILE_NOT_FOUND';
  static const String fileReadError = 'FILE_READ_ERROR';
  static const String fileWriteError = 'FILE_WRITE_ERROR';
  static const String fileSizeExceeded = 'FILE_SIZE_EXCEEDED';
  
  // Database errors
  static const String databaseError = 'DATABASE_ERROR';
  static const String databaseConnectionError = 'DATABASE_CONNECTION_ERROR';
  static const String databaseQueryError = 'DATABASE_QUERY_ERROR';
  
  // Business logic errors
  static const String businessError = 'BUSINESS_ERROR';
  static const String insufficientFunds = 'INSUFFICIENT_FUNDS';
  static const String creditLimitExceeded = 'CREDIT_LIMIT_EXCEEDED';
  static const String productOutOfStock = 'PRODUCT_OUT_OF_STOCK';
  
  // Unknown errors
  static const String unknownError = 'UNKNOWN_ERROR';
}

/// Error messages for different types of errors
class ErrorMessages {
  // Network errors
  static const String networkError = 'Network connection failed. Please check your internet connection.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String connectionError = 'Unable to connect to server. Please try again later.';
  
  // Server errors
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String badRequest = 'Invalid request. Please check your input.';
  static const String unauthorized = 'You are not authorized to perform this action.';
  static const String forbidden = 'Access denied. You don\'t have permission to perform this action.';
  static const String notFound = 'The requested resource was not found.';
  static const String internalServerError = 'Internal server error. Please try again later.';
  
  // Authentication errors
  static const String invalidCredentials = 'Invalid email or password. Please try again.';
  static const String tokenExpired = 'Your session has expired. Please login again.';
  static const String accountLocked = 'Your account has been locked. Please contact support.';
  static const String accountDisabled = 'Your account has been disabled. Please contact support.';
  
  // Validation errors
  static const String validationError = 'Please check your input and try again.';
  static const String requiredField = 'This field is required.';
  static const String invalidFormat = 'Invalid format. Please check your input.';
  static const String invalidLength = 'Invalid length. Please check your input.';
  static const String invalidRange = 'Invalid range. Please check your input.';
  
  // Cache errors
  static const String cacheError = 'Cache error occurred. Please try again.';
  static const String cacheNotFound = 'Cached data not found.';
  static const String cacheWriteError = 'Failed to save data to cache.';
  
  // Permission errors
  static const String permissionDenied = 'Permission denied. Please grant required permissions.';
  static const String cameraPermissionDenied = 'Camera permission denied. Please grant camera access.';
  static const String storagePermissionDenied = 'Storage permission denied. Please grant storage access.';
  
  // File errors
  static const String fileNotFound = 'File not found.';
  static const String fileReadError = 'Failed to read file.';
  static const String fileWriteError = 'Failed to write file.';
  static const String fileSizeExceeded = 'File size exceeds the maximum limit.';
  
  // Database errors
  static const String databaseError = 'Database error occurred. Please try again.';
  static const String databaseConnectionError = 'Database connection failed.';
  static const String databaseQueryError = 'Database query failed.';
  
  // Business logic errors
  static const String businessError = 'Business logic error occurred.';
  static const String insufficientFunds = 'Insufficient funds.';
  static const String creditLimitExceeded = 'Credit limit exceeded.';
  static const String productOutOfStock = 'Product is out of stock.';
  
  // Unknown errors
  static const String unknownError = 'An unknown error occurred. Please try again.';
}
