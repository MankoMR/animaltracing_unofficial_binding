/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: mal_formed_response_exception.dart
 * Project: animaltracing_unofficial_binding.
 */
import 'library_exception.dart';
import 'string_decoding_exception.dart';
import 'xml_missing_element_exception.dart';
import 'xml_parse_exception.dart';

/// Base class for Exceptions when the the response is different in
/// unexpected Ways.
///
/// See [StringDecodingException], [XmlParseException] and
/// [XmlMissingElementException].
class MalFormedResponseException extends LibraryException {}
