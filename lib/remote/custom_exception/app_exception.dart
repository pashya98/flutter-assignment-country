import 'dart:io';

import 'package:graphql/client.dart';

class AppException implements Exception {
  OperationException exception;
  AppException(this.exception);

  @override
  String toString() {
    String errorMessage = "Some problem has been occur, please try again later";
    Exception error = exception.linkException?.originalException as Exception;
    if (error is SocketException) {
      errorMessage =
          "Internet not available, please check your internet connection";
    }
    return errorMessage;
  }
}
