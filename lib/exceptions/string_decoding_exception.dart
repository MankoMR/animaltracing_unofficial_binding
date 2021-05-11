/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */

/// Gets thrown when the response can't be interpreted as
/// ascii, latin-1 or utf-8
class StringDecodingException extends FormatException {
  StringDecodingException(FormatException exception)
      : super(exception.message, exception.source, exception.offset);
}
