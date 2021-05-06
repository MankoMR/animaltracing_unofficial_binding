/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: 
 * Project: animaltracing_unofficial_binding.
 */
import 'package:animaltracing_unofficial_binding/exceptions/mal_formed_content_exception.dart';
import 'package:xml/xml.dart';

///Gets thrown when the response contained invalid xml or is missing
///really important Information.
class XmlParseException extends XmlParserException
    implements MalFormedContentException {
  XmlParseException(String message) : super(message);
  XmlParseException.from(XmlParserException exception)
      : super(exception.message,
            buffer: exception.buffer,
            column: exception.column,
            line: exception.line,
            position: exception.position);
}
