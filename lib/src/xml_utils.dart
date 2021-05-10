/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: xml_utils.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:xml/xml.dart';

import '../exceptions/xml_missing_element_exception.dart';

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

T? extractValue<T>(XmlElement parent, String name, String nameSpace,
    [NullabilityType nullabilityType = NullabilityType.required]) {
  final element = parent.getElement(name, namespace: nameSpace);
  switch (nullabilityType) {
    case NullabilityType.optionalElement:
      if (element == null) return null;
      break;
    case NullabilityType.nullable:
      if (element == null) {
        throw XmlMissingElementException(
            name, nameSpace, 'Is a required Element.');
      }
      if (element.getAttribute('nillable') == 'true') {
        return null;
      }
      break;
    case NullabilityType.required:
      if (element == null) {
        throw XmlMissingElementException(
            name, nameSpace, 'Is a required Element.');
      }
      if (element.innerText.isEmpty) {
        throw FormatException(
            '$name from $nameSpace does not contain a value. But its required');
      }
      break;
    default:
      throw UnimplementedError('Handle additional $nullabilityType');
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
