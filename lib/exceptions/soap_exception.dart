/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: soap_exception.dart
 * Project: animaltracing_unofficial_binding
 */
import 'library_exception.dart';

///Gets thrown when soap:Envelope contains a soap:Error.
class SoapException implements LibraryException {
  final String? errorCode;
  final String message;

  SoapException(this.errorCode, this.message);
}
