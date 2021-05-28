/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: parsing.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:xml/xml.dart';

import '../exceptions/xml_missing_element_exception.dart';
import 'shared.dart';

export 'shared.dart';

/// Function signature definition used in [ValueExtraction].extractList.
///
/// Implementers of this Function will usually return type extending
/// ResponseData.
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
      {bool isNullable = false, bool isOptional = false}) {
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
  /// This Function is purposely doing multiple things. This is to simplify the
  /// parsing in the Response Types and to maximize the reusability of code.
  T? extractValue<T>(String name, String nameSpace,
      {bool isNillable = false, bool isElementOptional = false}) {
    final element =
        getElement(name, namespace: nameSpace).nullabilityPass(name, nameSpace);
    if (element == null) {
      return null;
    }
    if (element.innerText.isEmpty) {
      throw FormatException('$name from $nameSpace needs to contain a value.');
    }
    final value = element.innerText;
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
        case XmlElement:
          return element as T;
        default:
          throw UnimplementedError('Implement conversion to $T');
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
