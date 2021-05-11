/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_exception.dart
 * Project: animaltracing_unofficial_binding
 */

import '../src/xml_utils/generation.dart';

/// Gets thrown when soap:Envelope contains a soap:Error.
class SoapException {
  /// See [Namespaces] for possible values.
  final String? errorCode;

  /// Explanation what went wrong.
  ///
  /// There is no guarantee in which language the [message] is.
  final String message;

  /// Create a [SoapException]
  const SoapException(this.errorCode, this.message);

  /// Returns readable Expression of the Exception
  @override
  String toString() {
    return '${super.toString()}: Envelope contained fault of type $errorCode: $message';
  }
}
