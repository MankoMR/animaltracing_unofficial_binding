/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: xml_missing_element_exception.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:animaltracing_unofficial_binding/exceptions/mal_formed_content_exception.dart';

class XmlMissingElementException implements MalFormedContentException {
  final String elementName;
  final String? nameSpace;
  final String? message;

  const XmlMissingElementException(
      this.elementName, this.nameSpace, this.message);

  @override
  String toString() {
    return '${super.toString()}: Missing $elementName from $nameSpace. $message';
  }
}
