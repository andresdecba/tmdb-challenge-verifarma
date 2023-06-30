import 'package:dio/dio.dart';

class InvalidApiKeyException implements Exception {}

class InvalidFormatException implements Exception {}

class InternalErrorException implements Exception {}

class ServerException implements Exception {}

// consultar códigos de error acá: https://developer.themoviedb.org/docs/errors

class ExceptionUtils {
  static Exception getExceptionFromStatusCode(DioException error) {
    var data = ErrorResponseModel.fromJson(error.response!.data);

    try {
      switch (data.statusCode) {
        case 4:
          return InvalidFormatException();
        case 7:
          return InvalidApiKeyException();
        case 11:
          return InternalErrorException();
        default:
          return ServerException();
      }
    } catch (_) {
      // excepción genérica, no hay codigo de error
      return ServerException();
    }
  }
}

class ErrorResponseModel {
  final int statusCode;
  final String message;
  final bool success;

  const ErrorResponseModel({
    required this.statusCode,
    required this.message,
    required this.success,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) => ErrorResponseModel(
        statusCode: json['status_code'],
        message: json['status_message'],
        success: json['success'],
      );
}
