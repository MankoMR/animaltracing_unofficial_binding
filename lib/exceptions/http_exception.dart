/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: http_exception.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'library_exception.dart';
import 'soap_exception.dart';

/// Gets thrown when service response contains a status code other than
/// status code for ok(200).
///
/// In case the response contains a valid soap:Envelope with soap:Fault,
/// a [SoapException] will be thrown instead.
class HttpException extends LibraryException {
  /// The status code from the response
  final int statusCode;

  /// The reason phrase for the [statusCode]
  final String reasonPhrase;

  const HttpException(this.statusCode, this.reasonPhrase);
}