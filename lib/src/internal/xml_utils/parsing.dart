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
/// Implementation of this Signature should parse [element] and return [T] that
/// represents [element].
typedef ItemConstructor<T> = T Function(XmlElement element);

/// Contains functions to support parsing Xml.
extension ValidationChecks on XmlElement? {
  /// Checks that the [isOptional] and [isNullable] properties
  /// of an XmlElement are as expected according to the WSDL of AnimalTracing.
  ///
  /// Also returns null when  XmlElement hast attribute `nil` with a value
  /// of `true`.
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
  /// Extracts the first [XmlElement] from this with the specified
  /// [name] and [namespace].
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

  /// Extracts a value of type [T] from the [text] of this. [XmlCDATA] and
  /// [XmlComment] are are handled appropriate, however other [XmlNodeType]
  /// in [text] can cause an [FormatException]
  ///
  /// [T] can be following Types: [bool], [int], [String], [BigInt], [DateTime]
  ///
  /// [isNullable] should be set according to specification in
  /// the WSDL of AnimalTracing. Checking the Optionality of the element should
  /// be done before calling this method.
  ///
  ///  Throws [FormatException] if parsing failed.
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
  T? extractPrimitiveValue<T extends Object>({
    bool isNullable = false,
  }) {
    //Throw exception if [element] contains something other than text,cdata or
    // comments.
    final disallowedElements = children.where((element) =>
        //Those Elements are interpreted
        !(element.nodeType == XmlNodeType.TEXT ||
            element.nodeType == XmlNodeType.CDATA ||
            //Those Elements are ignored
            element.nodeType == XmlNodeType.COMMENT ||
            //Attributes are ignored as well, since there are not in the body.
            element.nodeType == XmlNodeType.ATTRIBUTE));

    if (disallowedElements.isNotEmpty) {
      throw FormatException(
          '${name.local} from ${name.namespaceUri} should not contain something'
          'other than XML of type Text, CDATA or Comment (Comments are be '
          'ignored).');
    }

    // Handle case when the text in [element] is split with an [XmlComment].
    final interpretedElements = children.where((element) =>
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
          '${name.local} from ${name.namespaceUri} needs to contain a value. '
          'value: "$text"');
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
          return parseBool(value) as T;
        case String:
          return value as T;
        case DateTime:
          return DateTime.parse(value) as T;
        default:
          throw UnsupportedError('Parsing of $T is not supported. There might'
              'be another Extension method that supports extraction of T. See'
              'documentation.');
      }
    } on FormatException catch (exception) {
      throw FormatException(
          '${name.local} from ${name.namespaceUri} contains invalid value: '
          '${exception.message}',
          exception.source,
          exception.offset);
    }
  }

  /// specified [name] and [namespace].

  /// Extracts an value of type [T] from the first children Element with the
  ///
  /// [T] can be following Types: [bool], [int], [String], [BigInt], [DateTime]
  ///
  /// [isNullable] and [isOptional] should be set according to specification in
  /// the WSDL of AnimalTracing.
  ///
  /// Might throw [XmlMissingElementException]. See [nullabilityPass]. Throws
  /// [FormatException] if parsing failed.
  ///
  T? extractNestedPrimitiveValue<T extends Object>(
      String name, String nameSpace,
      {bool isNullable = false, bool isOptional = false}) {
    final element = extractXmlElement(name, nameSpace,
        isNullable: isNullable, isOptional: isOptional);
    if (element == null) {
      return null;
    }
    return element.extractPrimitiveValue<T>(isNullable: isNullable);
  }

  /// Extracts  a List of type [T] from this, where [itemName] and
  /// [itemNamespace] determine which children [XmlElement]s are passed to
  /// the [itemConstructor].
  ///
  /// Children not of type [XmlElement] will be ignored.
  ///
  /// [itemConstructor] creates [T] from element that are named as
  /// [itemName] from [itemNamespace]. [XmlELement] with other names are
  /// ignored.
  ///
  /// This does not handle the nullability of [this] or of the
  /// [children] Elements. The handling of nullability has to be done before or
  /// after calling this or within [itemConstructor].
  List<T> extractList<T extends Object>(String itemName, String itemNamespace,
      ItemConstructor<T> itemConstructor) {
    final list = <T>[];
    for (final element in children.whereType<XmlElement>()) {
      if (element.name.local == itemName &&
          element.name.namespaceUri == itemNamespace) {
        list.add(itemConstructor(element));
      }
    }
    return list;
  }
}

/// Tries parsing [source] to a bool.
///
/// Throws [FormatException] if parsing was not successful.
bool parseBool(String source) {
  final processedValue = source.trim().toLowerCase();
  if (processedValue == 'true') {
    return true;
  } else if (processedValue == 'false') {
    return false;
  } else {
    throw FormatException('Could not parse source as bool.', source);
  }
}
