/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/exceptions/mal_formed_content_exception.dart';

class StringDecodingException extends FormatException
    implements MalFormedContentException {
  StringDecodingException(FormatException exception)
      : super(exception.message, exception.source, exception.offset);
}
