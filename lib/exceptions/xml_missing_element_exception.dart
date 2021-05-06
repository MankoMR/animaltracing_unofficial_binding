/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: xml_missing_element_exception.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'library_exception.dart';

class XmlMissingElementException implements LibraryException {
  final String elementName;
  final String? nameSpace;
  final String? message;

  XmlMissingElementException(this.elementName, this.nameSpace, this.message);

  @override
  String toString() {
    return '${super.toString()}: Missing $elementName from $nameSpace. $message';
  }
}
