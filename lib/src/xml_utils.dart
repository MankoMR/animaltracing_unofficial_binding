/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: xml_utils.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:xml/xml.dart';

import '../core/core.dart';
import '../exceptions/xml_missing_element_exception.dart';

typedef ItemConstructor<T> = T Function(XmlElement element);

const String soapNameSpace = 'http://www.w3.org/2003/05/soap-envelope';
const String addressingNameSpace = 'http://www.w3.org/2005/08/addressing';
const String animalTracingNameSpace =
    'http://www.admin.ch/xmlns/Services/evd/Livestock/AnimalTracing/1';

//I had to look at code from the mockservice to get the correct namespace for
// the Xml-Attribute 'nil'
const schemaInstanceNameSpace = 'http://www.w3.org/2001/XMLSchema-instance';

const nameSpaceMapping = {
  soapNameSpace: 'soap',
  addressingNameSpace: 'wsa',
  animalTracingNameSpace: 'tns',
  schemaInstanceNameSpace: 'sch'
};

extension Parsing on XmlElement {
  T? extractValue<T>(String name, String nameSpace,
      {bool isNillable = false, bool isElementOptional = false}) {
    final element = getElement(name, namespace: nameSpace);

    if (isElementOptional && element == null) {
      return null;
    }
    if (element == null) {
      throw XmlMissingElementException(
          name, nameSpace, 'Is a required Element.');
    }
    if (isNillable &&
        element.getAttribute('nil', namespace: schemaInstanceNameSpace) ==
            'true') {
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

  List<T>? extractList<T>(String childrenName, String childrenNamespace,
      ItemConstructor<T> itemConstructor,
      [NullabilityType listNullabilityTyp = NullabilityType.required]) {
    final list = <T>[];
    for (final element in children
        .where((node) => node.nodeType == XmlNodeType.ELEMENT)
        .cast<XmlElement>()) {
      if (element.name.local == childrenName &&
          element.name.namespaceUri == childrenNamespace) {
        list.add(itemConstructor(element));
      } else {
        throw FormatException(
            '${name.local} from ${name.namespaceUri} should not contain ${element.name.local} from '
            '${element.name.namespaceUri}. It should contain $childrenName from $childrenNamespace.',
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

extension RequestDataExtension on RequestData {
  void buildNullableElement(
    XmlBuilder builder,
    String elementName,
    String namespace,
    NullabilityType nullabilityType,
    Object? value,
  ) {
    if (value == null) {
      switch (nullabilityType) {
        case NullabilityType.optionalElement:
          return;
        case NullabilityType.nullable:
          builder.element(
            elementName,
            namespace: namespace,
            nest: () {
              //I had to look at code from the mockservice to get the correct
              // Xml-Attribute name for element which are marked with
              // nillable="true" in the wsdl-Definition file
              //and the specific namespace in schemaInstanceNameSpace
              builder.attribute('nil', 'true',
                  namespace: schemaInstanceNameSpace);
            },
          );
          break;
        case NullabilityType.required:
          throw UnsupportedError(
              'Should not be called with a nullabilityType set to required');
      }
    } else {
      builder.element(elementName, namespace: namespace, nest: value);
    }
  }
}

/*
typedef ItemBuilder<T> = void Function(XmlBuilder builder, T value);
void buildList<T>(
  XmlBuilder builder,
  String elementName,
  String namespace,
  NullabilityType nullabilityType,
  List<T>? values,
  ItemBuilder<T> itemBuilder,
) {
  if (values == null) {
    builder.element(
      elementName,
      namespace: namespace,
      nest: () {
        builder.attribute('isNill', 'true');
      },
    );
  } else {
    builder.element(elementName, namespace: namespace, nest: () {
      for (final value in values) {
        itemBuilder(builder, value);
      }
    });
  }
}
 */

enum NullabilityType {
  optionalElement,
  nullable,
  required,
}
