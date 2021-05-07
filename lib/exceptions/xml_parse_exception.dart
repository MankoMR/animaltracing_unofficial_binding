/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */
import 'package:xml/xml.dart';

import 'mal_formed_response_exception.dart';

/// Exception when the response contains invalid xml.
class XmlParseException extends XmlParserException
    implements MalFormedResponseException {
  XmlParseException(String message) : super(message);
  XmlParseException.from(XmlParserException exception)
      : super(exception.message,
            buffer: exception.buffer,
            column: exception.column,
            line: exception.line,
            position: exception.position);
}
