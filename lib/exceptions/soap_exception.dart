/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_exception.dart
 * Project: animaltracing_unofficial_binding
 */

/// Gets thrown when soap:Envelope contains a soap:Error.
class SoapException {
  final String? errorCode;
  final String message;

  const SoapException(this.errorCode, this.message);

  /// Returns readable Expression of the Exception
  @override
  String toString() {
    return '${super.toString()}: Envelope contained fault of type $errorCode: $message';
  }
}
