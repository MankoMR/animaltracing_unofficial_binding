/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: parsing.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:xml/xml.dart';

import '../exceptions/xml_missing_element_exception.dart';
import 'shared.dart';

export 'shared.dart';

/// Function signature definition used in [ValueExtraction.extractList].
///
/// Implementers of this Function will usually return a object implementing
/// [ResponseData].
typedef ItemConstructor<T> = T Function(XmlElement element);

/// Contains functions to support parsing Xml.
extension ValidationChecks on XmlElement? {
  /// Checks that the [isOptional] and [isNullable] properties
  /// of an XmlElement are as expected according to the WSDL of AnimalTracing.
  ///
  /// Also returns null when  XmlElement hast attribute '''nil''' with a value
  /// of '''true'''.
  ///
  /// Throws a [XmlMissingElementException] when XmlElement is not optional but
  /// is null. [name] and [nameSpace] are required as parameters for
  /// the exception.
  XmlElement? nullabilityPass(String name, String nameSpace,
      {required bool isNullable, required bool isOptional}) {
    if (isOptional && this == null) {
      return null;
    }
    if (this == null) {
      throw XmlMissingElementException(
          name, nameSpace, 'Is a required Element.');
    }
    if (isNullable &&
        this!.getAttribute('nil', namespace: Namespaces.schemaInstance) ==
            'true') {
      return null;
    }
    return this;
  }
}

/// Helper functions to extract a value from xml.
extension ValueExtraction on XmlElement {
  /// Extracts first [XmlElement] from this with the specified
  /// [name] and [nameSpace].
  ///
  /// [isNullable] and [isOptional] should be set according to specification in
  /// the WSDL of AnimalTracing.
  ///
  /// Might throw [XmlMissingElementException]. See [nullabilityPass].
  ///
  /// Important: Add tests for the function if implementation gets additional
  /// code. Currently [extractXmlElement] is tested through testing
  /// [nullabilityPass] since this function only a wrapper
  /// around [nullabilityPass].
  XmlElement? extractXmlElement(String name, String nameSpace,
      {bool isNullable = false, bool isOptional = false}) {
    final element = getElement(name, namespace: nameSpace).nullabilityPass(
        name, nameSpace,
        isNullable: isNullable, isOptional: isOptional);
    return element;
  }

  /// Extracts an value of type [T] from the first children Element with the
  /// specified [name] and [nameSpace].
  ///
  /// [T] can be following Types: [bool], [int], [String], [BigInt], [DateTime]
  ///
  /// [isNullable] and [isOptional] should be set according to specification in
  /// the WSDL of AnimalTracing.
  ///
  /// Might throw [XmlMissingElementException]. See [nullabilityPass]. Throws
  /// [FormatException] if parsing failed.
  ///
  /// Note: If parsing of an additional Type is added, the following conditions
  /// needs to be meet:
  /// * The type has a constructor that takes a String which
  /// represents a possible instance of the type.
  /// * An empty String must not represent a valid instance of the type. In
  ///   this needs to be verified by writing a Test.
  /// * The String representation of a
  /// value of the Type is easy to understand and parse.
  ///
  T? extractPrimitiveValue<T>(String name, String nameSpace,
      {bool isNullable = false, bool isOptional = false}) {
    final element = getElement(name, namespace: nameSpace).nullabilityPass(
        name, nameSpace,
        isNullable: isNullable, isOptional: isOptional);
    if (element == null) {
      return null;
    }

    //Throw exception if [element] contains something other than text,cdata or
    // comments.
    final disallowedElements = element.children.where((element) =>
        //Those Elements will be interpreted
        !(element.nodeType == XmlNodeType.TEXT ||
            element.nodeType == XmlNodeType.CDATA ||
            //Those Elements will be ignored
            element.nodeType == XmlNodeType.COMMENT ||
            //Attributes are ignored as well, since there are not in the body.
            element.nodeType == XmlNodeType.ATTRIBUTE));

    if (disallowedElements.isNotEmpty) {
      throw FormatException('$name from $nameSpace should not contain something'
          'other than XML of type Text, CDATA or Comment (Comments will be '
          'ignored).');
    }

    // Handle case when the text in [element] is split with an [XmlComment].
    final interpretedElements = element.children.where((element) =>
        element.nodeType == XmlNodeType.TEXT ||
        element.nodeType == XmlNodeType.CDATA);
    final buffer = StringBuffer();
    for (final element in interpretedElements) {
      buffer.write(element.text);
    }
    final value = buffer.toString();
    buffer.clear();

    if (value.isEmpty && !isNullable) {
      throw FormatException(
          '$name from $nameSpace needs to contain a value. value:');
    }
    if (value.isEmpty && isNullable) {
      return null;
    }
    //Catch all Format exceptions to enrich with additional information
    try {
      switch (T) {
        case int:
          return int.parse(value) as T;
        case BigInt:
          return BigInt.parse(value) as T;
        case bool:
          final processedValue = value.trim().toLowerCase();
          if (processedValue == 'true') {
            return true as T;
          } else if (processedValue == 'false') {
            return false as T;
          } else {
            throw FormatException('Could not parse source as bool.', value);
          }
        case String:
          return value as T;
        case DateTime:
          return DateTime.parse(value) as T;
        case dynamic:
          throw UnsupportedError('The Type of the value to extract needs to be '
              'specified. It can not be dynamic');
        default:
          throw UnsupportedError('Parsing of $T is not supported. There might'
              'be another Extension method that supports extraction of T. See'
              'documentation.');
      }
    } on FormatException catch (exception) {
      throw FormatException(
          '$name of $nameSpace contains invalid value: ${exception.message}',
          exception.source,
          exception.offset);
    }
  }

  /// Extracts  a List of type [T] from this, where [childrenName] and
  /// [childrenNamespace] determine which children [XmlElement]s are passed to
  /// the [itemConstructor].
  ///
  /// [itemConstructor] is the method which creates a [T] per selected
  /// children.
  ///
  /// [listNullabilityTyp] will be removed in a later version.
  List<T>? extractList<T>(
      String childrenName,
      String childrenNamespace,
      ItemConstructor<T> itemConstructor,
      [@Deprecated('Handling of NullabilityType of the list should be done '
          'outside of this function.')
          NullabilityType listNullabilityTyp = NullabilityType.required]) {
    final list = <T>[];
    for (final element in children
        .where((node) => node.nodeType == XmlNodeType.ELEMENT)
        .cast<XmlElement>()) {
      if (element.name.local == childrenName &&
          element.name.namespaceUri == childrenNamespace) {
        list.add(itemConstructor(element));
      } else {
        throw FormatException(
            '${name.local} from ${name.namespaceUri} should not contain '
            '${element.name.local} from ${element.name.namespaceUri}. '
            'It should contain $childrenName from $childrenNamespace.',
            element.toXmlString(pretty: true));
      }
    }
    switch (listNullabilityTyp) {
      case NullabilityType.optionalElement:
      case NullabilityType.nullable:
        return list.isEmpty ? null : list;
      case NullabilityType.required:
        return list;
      default:
        throw UnimplementedError('Handle additional $listNullabilityTyp');
    }
  }
}
