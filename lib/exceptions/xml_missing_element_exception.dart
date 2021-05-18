/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: xml_missing_element_exception.dart
 * Project: animaltracing_unofficial_binding.
 */

/// Gets thrown when the response does not contain the [elementName]
class XmlMissingElementException extends FormatException {
  /// Name of the XmlElement which is missed.
  final String elementName;

  /// Namespace to which the missed element belongs
  final String? nameSpace;

  ///  Create [XmlMissingElementException]
  const XmlMissingElementException(
      this.elementName, this.nameSpace, String? message)
      : super(message ?? 'Missing XmlElement');

  /// Returns readable Expression of the Exception
  @override
  String toString() {
    return '${super.toString()}: Missing $elementName from $nameSpace. $message';
  }
}
