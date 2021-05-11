/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: string_decoding_exception.dart
 * Project: animaltracing_unofficial_binding.
 */

/// Gets thrown when the response can't be interpreted as
/// utf-8 or other supported charsets
///
// Used to enrich context why a exception is thrown.
class StringDecodingException extends FormatException {
  /// Create a [StringDecodingException] from a [FormatException].
  StringDecodingException(FormatException exception)
      : super(exception.message, exception.source, exception.offset);
}
