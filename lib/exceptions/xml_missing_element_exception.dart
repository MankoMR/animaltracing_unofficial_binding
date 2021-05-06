/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: xml_missing_element_exception.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'mal_formed_response_exception.dart';

/// Gets thrown when the response does not contain the [elementName]
class XmlMissingElementException implements MalFormedResponseException {
  /// Name of the XmlElement which is missed.
  final String elementName;

  /// Namespace to which the missed element belongs
  final String? nameSpace;

  /// Some additional information.
  final String? message;

  const XmlMissingElementException(
      this.elementName, this.nameSpace, this.message);

  /// Returns readable Expression of the Exception
  @override
  String toString() {
    return '${super.toString()}: Missing $elementName from $nameSpace. $message';
  }
}
