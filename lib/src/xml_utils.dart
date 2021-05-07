/*
 * Copyright (c) 2021, Manuel Koloska. All Rights reserved.
 * Filename: xml_utils.dart
 * Project: animaltracing_unofficial_binding.
 */

import 'package:xml/xml.dart';

const String soapNameSpace = 'http://www.w3.org/2003/05/soap-envelope';
const String adressingNameSpace = 'http://www.w3.org/2005/08/addressing';

const nameSpaceMapping = {
  soapNameSpace: 'soap',
  adressingNameSpace: 'wsa',
};

void buildNullableElement(
  XmlBuilder builder,
  String elementName,
  String namespace,
  NullabilityType nullabilityType,
  Object? value,
) {
  if (value == null) {
    builder.element(
      elementName,
      namespace: namespace,
      nest: () {
        builder.attribute('isNill', 'true');
      },
    );
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
}
