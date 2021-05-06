/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */
import 'library_exception.dart';

class HttpException extends LibraryException {
  final int statusCode;
  final String reasonPhrase;

  const HttpException(this.statusCode, this.reasonPhrase);
}
